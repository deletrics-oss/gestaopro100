import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/lib/supabase";
import { format, startOfMonth, endOfMonth } from "date-fns";

export function useDashboardData() {
  const currentMonth = new Date();

  const { data: sales = [], isLoading: loadingSales } = useQuery({
    queryKey: ['dashboard-sales'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('sales')
        .select('*')
        .gte('sale_date', format(startOfMonth(currentMonth), 'yyyy-MM-dd'))
        .lte('sale_date', format(endOfMonth(currentMonth), 'yyyy-MM-dd'));
      if (error) throw error;
      return data || [];
    },
  });

  const { data: expenses = [], isLoading: loadingExpenses } = useQuery({
    queryKey: ['dashboard-expenses'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('expenses')
        .select('*')
        .gte('expense_date', format(startOfMonth(currentMonth), 'yyyy-MM-dd'))
        .lte('expense_date', format(endOfMonth(currentMonth), 'yyyy-MM-dd'));
      if (error) throw error;
      return data || [];
    },
  });

  // Buscar movimentações de caixa
  const { data: cashMovements = [], isLoading: loadingCash } = useQuery({
    queryKey: ['dashboard-cash-movements'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('cash_movements')
        .select('*')
        .gte('movement_date', format(startOfMonth(currentMonth), 'yyyy-MM-dd'))
        .lte('movement_date', format(endOfMonth(currentMonth), 'yyyy-MM-dd'))
        .order('movement_date', { ascending: false });
      if (error) throw error;
      return data || [];
    },
  });

  const totalVendasMes = sales.reduce((sum: number, s: any) => sum + (s.total_revenue || 0), 0);
  const totalDespesasMes = expenses.reduce((sum: number, e: any) => sum + (e.value || 0), 0);
  const totalLucroMes = sales.reduce((sum: number, s: any) => sum + (s.profit || 0), 0);

  // Calcular gestão de caixa
  const entradasCaixa = cashMovements
    .filter((m: any) => m.type === 'entrada')
    .reduce((sum: number, m: any) => sum + (m.value || 0), 0);
  
  const saidasCaixa = cashMovements
    .filter((m: any) => m.type === 'saida')
    .reduce((sum: number, m: any) => sum + (m.value || 0), 0);
  
  const saldoCaixa = entradasCaixa - saidasCaixa;

  return {
    sales,
    expenses,
    cashMovements,
    totalVendasMes,
    totalDespesasMes,
    totalLucroMes,
    saldoCaixa,
    entradasCaixa,
    saidasCaixa,
    isLoading: loadingSales || loadingExpenses || loadingCash,
  };
}
