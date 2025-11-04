import { supabase } from "@/lib/supabase";

export interface BackupData {
  products: any[];
  sales: any[];
  customers: any[];
  suppliers: any[];
  expenses: any[];
  services: any[];
  materials: any[];
  employees: any[];
  machines_vehicles: any[];
  production_orders: any[];
  marketplace_orders: any[];
}

export async function exportFullSystemBackup(): Promise<string> {
  try {
    // Buscar dados de todas as tabelas
    const [
      { data: products },
      { data: sales },
      { data: customers },
      { data: suppliers },
      { data: expenses },
      { data: services },
      { data: materials },
      { data: employees },
      { data: machines },
      { data: production },
      { data: marketplace }
    ] = await Promise.all([
      supabase.from('products').select('*'),
      supabase.from('sales').select('*'),
      supabase.from('customers').select('*'),
      supabase.from('suppliers').select('*'),
      supabase.from('expenses').select('*'),
      supabase.from('services').select('*'),
      supabase.from('materials').select('*'),
      supabase.from('employees').select('*'),
      supabase.from('machines_vehicles').select('*'),
      supabase.from('production_orders').select('*'),
      supabase.from('marketplace_orders').select('*')
    ]);

    let csv = 'sep=,\n\n\n';

    // Products
    if (products && products.length > 0) {
      csv += '### TABELA: Products ###\n';
      csv += '"name","sku","category","cost_price","unit_price","stock_quantity","minimum_stock","location","description","active"\n';
      products.forEach(p => {
        csv += `"${p.name || ''}","${p.sku || ''}","${p.category || ''}","${p.cost_price || 0}","${p.unit_price || 0}","${p.stock_quantity || 0}","${p.minimum_stock || 0}","${p.location || ''}","${p.description || ''}","${p.active !== false}"\n`;
      });
      csv += '\n\n';
    }

    // Sales
    if (sales && sales.length > 0) {
      csv += '### TABELA: Sales ###\n';
      csv += '"product_name","customer_name","quantity","unit_price","cost_price","total_revenue","total_cost","profit","sale_date","payment_method","notes"\n';
      sales.forEach(s => {
        csv += `"${s.product_name || ''}","${s.customer_name || ''}","${s.quantity || 0}","${s.unit_price || 0}","${s.cost_price || 0}","${s.total_revenue || 0}","${s.total_cost || 0}","${s.profit || 0}","${s.sale_date || ''}","${s.payment_method || ''}","${s.notes || ''}"\n`;
      });
      csv += '\n\n';
    }

    // Customers
    if (customers && customers.length > 0) {
      csv += '### TABELA: Customers ###\n';
      csv += '"name","email","phone","address","city","state","zip_code","cpf_cnpj","birth_date","notes"\n';
      customers.forEach(c => {
        csv += `"${c.name || ''}","${c.email || ''}","${c.phone || ''}","${c.address || ''}","${c.city || ''}","${c.state || ''}","${c.zip_code || ''}","${c.cpf_cnpj || ''}","${c.birth_date || ''}","${c.notes || ''}"\n`;
      });
      csv += '\n\n';
    }

    // Suppliers
    if (suppliers && suppliers.length > 0) {
      csv += '### TABELA: Suppliers ###\n';
      csv += '"name","cnpj","contact_person","email","phone","address","city","state","zip_code","notes"\n';
      suppliers.forEach(s => {
        csv += `"${s.name || ''}","${s.cnpj || ''}","${s.contact_person || ''}","${s.email || ''}","${s.phone || ''}","${s.address || ''}","${s.city || ''}","${s.state || ''}","${s.zip_code || ''}","${s.notes || ''}"\n`;
      });
      csv += '\n\n';
    }

    // Expenses
    if (expenses && expenses.length > 0) {
      csv += '### TABELA: Expenses ###\n';
      csv += '"description","category","value","expense_date","supplier_name","payment_method","due_date","paid","notes"\n';
      expenses.forEach(e => {
        csv += `"${e.description || ''}","${e.category || ''}","${e.value || 0}","${e.expense_date || ''}","${e.supplier_name || ''}","${e.payment_method || ''}","${e.due_date || ''}","${e.paid || false}","${e.notes || ''}"\n`;
      });
      csv += '\n\n';
    }

    // Services
    if (services && services.length > 0) {
      csv += '### TABELA: Services ###\n';
      csv += '"service_type","customer_name","employee_name","total_value","cost","profit","service_date","status","payment_method","description","notes"\n';
      services.forEach(s => {
        csv += `"${s.service_type || ''}","${s.customer_name || ''}","${s.employee_name || ''}","${s.total_value || 0}","${s.cost || 0}","${s.profit || 0}","${s.service_date || ''}","${s.status || ''}","${s.payment_method || ''}","${s.description || ''}","${s.notes || ''}"\n`;
      });
      csv += '\n\n';
    }

    // Materials
    if (materials && materials.length > 0) {
      csv += '### TABELA: Materials ###\n';
      csv += '"material_name","unit","quantity","minimum_quantity","unit_price","location","description"\n';
      materials.forEach(m => {
        csv += `"${m.material_name || ''}","${m.unit || ''}","${m.quantity || 0}","${m.minimum_quantity || 0}","${m.unit_price || 0}","${m.location || ''}","${m.description || ''}"\n`;
      });
      csv += '\n\n';
    }

    // Employees
    if (employees && employees.length > 0) {
      csv += '### TABELA: Employees ###\n';
      csv += '"name","role","cpf","email","phone","address","city","state","zip_code","hire_date","salary","birth_date","active"\n';
      employees.forEach(e => {
        csv += `"${e.name || ''}","${e.role || ''}","${e.cpf || ''}","${e.email || ''}","${e.phone || ''}","${e.address || ''}","${e.city || ''}","${e.state || ''}","${e.zip_code || ''}","${e.hire_date || ''}","${e.salary || 0}","${e.birth_date || ''}","${e.active !== false}"\n`;
      });
      csv += '\n\n';
    }

    // Machines & Vehicles
    if (machines && machines.length > 0) {
      csv += '### TABELA: Machines_Vehicles ###\n';
      csv += '"name","type","brand","model","serial_number","purchase_date","purchase_value","status","location","last_maintenance","next_maintenance","notes"\n';
      machines.forEach(m => {
        csv += `"${m.name || ''}","${m.type || ''}","${m.brand || ''}","${m.model || ''}","${m.serial_number || ''}","${m.purchase_date || ''}","${m.purchase_value || 0}","${m.status || ''}","${m.location || ''}","${m.last_maintenance || ''}","${m.next_maintenance || ''}","${m.notes || ''}"\n`;
      });
      csv += '\n\n';
    }

    // Production Orders
    if (production && production.length > 0) {
      csv += '### TABELA: ProductionOrders ###\n';
      csv += '"order_number","product_name","employee_name","quantity","status","priority","start_date","end_date","notes"\n';
      production.forEach(p => {
        csv += `"${p.order_number || ''}","${p.product_name || ''}","${p.employee_name || ''}","${p.quantity || 0}","${p.status || ''}","${p.priority || ''}","${p.start_date || ''}","${p.end_date || ''}","${p.notes || ''}"\n`;
      });
      csv += '\n\n';
    }

    // Marketplace Orders
    if (marketplace && marketplace.length > 0) {
      csv += '### TABELA: MarketplaceOrders ###\n';
      csv += '"order_number","customer_name","status","integration","items","completed_by"\n';
      marketplace.forEach(m => {
        const items = JSON.stringify(m.items || []).replace(/"/g, '""');
        csv += `"${m.order_number || ''}","${m.customer_name || ''}","${m.status || ''}","${m.integration || ''}","${items}","${m.completed_by || ''}"\n`;
      });
    }

    return csv;
  } catch (error) {
    console.error('Erro ao exportar backup:', error);
    throw error;
  }
}

export async function importFullSystemBackup(csvContent: string): Promise<void> {
  try {
    const sections = csvContent.split('### TABELA:');
    
    for (const section of sections) {
      if (!section.trim()) continue;

      const lines = section.split('\n').filter(l => l.trim());
      if (lines.length < 2) continue;

      const tableName = lines[0].replace('###', '').trim();
      const headers = lines[1].replace(/"/g, '').split(',');
      const rows = lines.slice(2);

      let tableMapping: any = {
        'Products': { table: 'products', headers },
        'Sales': { table: 'sales', headers },
        'Customers': { table: 'customers', headers },
        'Suppliers': { table: 'suppliers', headers },
        'Expenses': { table: 'expenses', headers },
        'Services': { table: 'services', headers },
        'Materials': { table: 'materials', headers },
        'Employees': { table: 'employees', headers },
        'Machines_Vehicles': { table: 'machines_vehicles', headers },
        'ProductionOrders': { table: 'production_orders', headers },
        'MarketplaceOrders': { table: 'marketplace_orders', headers }
      };

      const config = tableMapping[tableName];
      if (!config) continue;

      const records = rows.map(row => {
        const values = row.match(/("(?:[^"]|"")*"|[^,]+)/g)?.map(v => 
          v.replace(/^"/, '').replace(/"$/, '').replace(/""/g, '"')
        ) || [];
        
        const record: any = {};
        config.headers.forEach((header: string, index: number) => {
          const value = values[index] || '';
          record[header] = value === '' ? null : value;
        });
        return record;
      });

      // Insert em lotes
      const batchSize = 50;
      for (let i = 0; i < records.length; i += batchSize) {
        const batch = records.slice(i, i + batchSize);
        await supabase.from(config.table).insert(batch);
      }
    }
  } catch (error) {
    console.error('Erro ao importar backup:', error);
    throw error;
  }
}
