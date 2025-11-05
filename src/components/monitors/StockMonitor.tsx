import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Package, AlertTriangle } from "lucide-react";
import { supabase } from "@/lib/supabase";
import { useQuery } from "@tanstack/react-query";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";

export function StockMonitor() {
  const { data: products = [] } = useQuery({
    queryKey: ['stock-monitor'],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from('products')
        .select('*')
        .eq('active', true)
        .order('stock_quantity', { ascending: true })
        .limit(8);
      if (error) throw error;
      return data || [];
    },
    refetchInterval: 10000,
  });

  const lowStock = products.filter((p: any) => p.stock_quantity <= (p.minimum_stock || 0)).length;

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-orange-900 to-slate-900 p-8">
      <div className="max-w-7xl mx-auto">
        <div className="mb-8 text-center">
          <div className="flex items-center justify-center gap-4 mb-4">
            <Package className="w-16 h-16 text-orange-400" />
            <h1 className="text-6xl font-bold text-white">ESTOQUE</h1>
          </div>
          <p className="text-2xl text-slate-300">
            {format(new Date(), "dd 'de' MMMM 'de' yyyy - HH:mm", { locale: ptBR })}
          </p>
          {lowStock > 0 && (
            <div className="mt-4 bg-red-500/20 border border-red-500 rounded-lg px-6 py-3 inline-block">
              <p className="text-red-300 font-bold">⚠️ {lowStock} produto(s) com estoque baixo!</p>
            </div>
          )}
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {products.map((product: any) => {
            const isLowStock = product.stock_quantity <= (product.minimum_stock || 0);
            return (
              <Card key={product.id} className={`border-2 shadow-2xl ${
                isLowStock 
                  ? 'bg-gradient-to-br from-red-900 to-orange-900 border-red-600' 
                  : 'bg-gradient-to-br from-orange-900 to-yellow-900 border-orange-600'
              }`}>
                <CardContent className="pt-6">
                  <div className="text-center">
                    {isLowStock ? (
                      <AlertTriangle className="w-12 h-12 mx-auto mb-4 text-red-300" />
                    ) : (
                      <Package className="w-12 h-12 mx-auto mb-4 text-orange-300" />
                    )}
                    <h3 className="text-xl font-bold text-white mb-2">{product.name}</h3>
                    {product.category && (
                      <p className="text-orange-200 mb-3 text-sm">{product.category}</p>
                    )}
                    <div className="bg-black/30 rounded-lg p-4 mb-3">
                      <p className="text-orange-300">Estoque</p>
                      <p className={`text-4xl font-bold ${isLowStock ? 'text-red-300' : 'text-white'}`}>
                        {product.stock_quantity}
                      </p>
                      {product.minimum_stock > 0 && (
                        <p className="text-orange-200 text-sm mt-1">Mín: {product.minimum_stock}</p>
                      )}
                    </div>
                    <Badge className={isLowStock ? 'bg-red-500' : 'bg-green-500'}>
                      {isLowStock ? 'Estoque Baixo' : 'Normal'}
                    </Badge>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      </div>
    </div>
  );
}
