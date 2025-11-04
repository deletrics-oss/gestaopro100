import { supabase } from "@/lib/supabase";
import { toast } from "sonner";

interface CSVProduct {
  product_name: string;
  variation_name: string;
  total_cost: number;
  sale_price: number;
  stock_quantity: number;
}

export async function importProductsFromCSV(csvContent: string): Promise<void> {
  const lines = csvContent.split('\n');
  let dataStarted = false;
  const products: any[] = [];

  for (const line of lines) {
    if (line.trim().startsWith('### TABELA: Products ###')) {
      dataStarted = true;
      continue;
    }

    if (!dataStarted || line.trim() === '' || line.trim().startsWith('###')) {
      if (line.trim().startsWith('###') && line !== '### TABELA: Products ###') {
        break; // Nova tabela começou
      }
      continue;
    }

    // Pular cabeçalho
    if (line.includes('"product_name"')) {
      continue;
    }

    try {
      // Parse CSV line
      const values = line.match(/(?:[^,"]+|"[^"]*")+/g);
      if (!values || values.length < 6) continue;

      const cleanValue = (val: string) => val.replace(/^"|"$/g, '').trim();

      const product = {
        name: `${cleanValue(values[0])} - ${cleanValue(values[1])}`,
        sku: cleanValue(values[10]) || undefined,
        cost_price: parseFloat(cleanValue(values[6])) || 0,
        unit_price: parseFloat(cleanValue(values[7])) || 0,
        stock_quantity: parseInt(cleanValue(values[9])) || 0,
        minimum_stock: 5,
        description: `Material: ${cleanValue(values[3])}, Mão de obra: ${cleanValue(values[4])}, Outros: ${cleanValue(values[5])}`,
        category: 'Produtos Importados',
        active: true,
      };

      products.push(product);
    } catch (error) {
      console.error('Erro ao processar linha:', line, error);
    }
  }

  if (products.length === 0) {
    toast.error("Nenhum produto encontrado no arquivo CSV");
    return;
  }

  // Inserir produtos em lotes
  try {
    const { error } = await supabase.from('products').insert(products);
    if (error) throw error;
    
    toast.success(`${products.length} produtos importados com sucesso!`);
  } catch (error: any) {
    console.error('Erro ao importar produtos:', error);
    toast.error(`Erro ao importar: ${error.message}`);
  }
}

export async function importCustomersFromCSV(csvContent: string): Promise<void> {
  const lines = csvContent.split('\n');
  let dataStarted = false;
  const customers: any[] = [];

  for (const line of lines) {
    if (line.trim().startsWith('### TABELA: Customers ###') || line.trim().startsWith('### TABELA: Clientes ###')) {
      dataStarted = true;
      continue;
    }

    if (!dataStarted || line.trim() === '' || line.trim().startsWith('###')) {
      if (line.trim().startsWith('###') && !line.includes('Customer') && !line.includes('Cliente')) {
        break;
      }
      continue;
    }

    // Pular cabeçalho
    if (line.includes('"customer_name"') || line.includes('"nome"')) {
      continue;
    }

    try {
      const values = line.match(/(?:[^,"]+|"[^"]*")+/g);
      if (!values || values.length < 3) continue;

      const cleanValue = (val: string) => val.replace(/^"|"$/g, '').trim();

      const customer = {
        name: cleanValue(values[0]),
        email: cleanValue(values[1]) || undefined,
        phone: cleanValue(values[2]) || undefined,
        cpf_cnpj: cleanValue(values[3]) || undefined,
        address: cleanValue(values[4]) || undefined,
        city: cleanValue(values[5]) || undefined,
        state: cleanValue(values[6]) || undefined,
      };

      customers.push(customer);
    } catch (error) {
      console.error('Erro ao processar linha:', line, error);
    }
  }

  if (customers.length === 0) {
    toast.error("Nenhum cliente encontrado no arquivo CSV");
    return;
  }

  try {
    const { error } = await supabase.from('customers').insert(customers);
    if (error) throw error;
    
    toast.success(`${customers.length} clientes importados com sucesso!`);
  } catch (error: any) {
    console.error('Erro ao importar clientes:', error);
    toast.error(`Erro ao importar: ${error.message}`);
  }
}
