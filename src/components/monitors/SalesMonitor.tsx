import { useState, useEffect } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { ShoppingCart, TrendingUp, Package } from "lucide-react";
import { supabase } from "@/lib/supabase";
import { useQuery } from "@tanstack/react-query";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";
import { MonitorAudioControls } from "./MonitorAudioControls";

export function SalesMonitor() {
  const [slideSpeed, setSlideSpeed] = useState(5000);
  
  const { data: sales = [] } = useQuery({
    queryKey: ['sales-monitor'],
    queryFn: async () => {
      const today = new Date().toISOString().split('T')[0];
      const { data, error } = await (supabase as any)
        .from('sales')
        .select('*')
        .gte('sale_date', today)
        .order('created_date', { ascending: false })
        .limit(8);
      if (error) throw error;
      return data || [];
    },
    refetchInterval: 5000,
  });

  const totalVendas = sales.reduce((sum: number, s: any) => sum + (s.total_revenue || 0), 0);
  const totalItens = sales.reduce((sum: number, s: any) => sum + (s.quantity || 0), 0);

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-green-900 to-slate-900 p-8">
      <MonitorAudioControls context="sales" onSpeedChange={setSlideSpeed} />
      <div className="max-w-7xl mx-auto">
        <div className="mb-8 text-center">
          <div className="flex items-center justify-center gap-4 mb-4">
            <ShoppingCart className="w-16 h-16 text-green-400" />
            <h1 className="text-6xl font-bold text-white">VENDAS DO DIA</h1>
          </div>
          <p className="text-2xl text-slate-300">
            {format(new Date(), "dd 'de' MMMM 'de' yyyy - HH:mm", { locale: ptBR })}
          </p>
          <div className="flex justify-center gap-8 mt-6">
            <div className="bg-black/40 rounded-lg px-8 py-4">
              <p className="text-green-300 text-lg">Total Vendido</p>
              <p className="text-4xl font-bold text-white">R$ {totalVendas.toFixed(2)}</p>
            </div>
            <div className="bg-black/40 rounded-lg px-8 py-4">
              <p className="text-green-300 text-lg">Itens Vendidos</p>
              <p className="text-4xl font-bold text-white">{totalItens}</p>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {sales.map((sale: any) => (
            <Card key={sale.id} className="bg-gradient-to-br from-green-900 to-emerald-900 border-2 border-green-600 shadow-2xl">
              <CardContent className="pt-6">
                <div className="text-center">
                  <Package className="w-12 h-12 mx-auto mb-4 text-green-300" />
                  <h3 className="text-xl font-bold text-white mb-2">{sale.product_name}</h3>
                  {sale.customer_name && (
                    <p className="text-green-200 mb-3">{sale.customer_name}</p>
                  )}
                  <div className="bg-black/30 rounded-lg p-3 mb-3">
                    <p className="text-green-300">Qtd: {sale.quantity}</p>
                    <p className="text-2xl font-bold text-white">R$ {sale.total_revenue?.toFixed(2)}</p>
                  </div>
                  <p className="text-green-300 text-sm">{sale.payment_method || 'N/A'}</p>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </div>
  );
}
