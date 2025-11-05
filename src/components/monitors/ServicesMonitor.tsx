import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Wrench, CheckCircle2, Clock, AlertCircle } from "lucide-react";
import { supabase } from "@/lib/supabase";
import { useQuery } from "@tanstack/react-query";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";
import { MonitorAudioControls } from "./MonitorAudioControls";

export function ServicesMonitor() {
  const [slideSpeed, setSlideSpeed] = useState(5000);
  
  const { data: services = [] } = useQuery({
    queryKey: ['services-monitor'],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from('services')
        .select('*')
        .order('service_date', { ascending: false })
        .limit(8);
      if (error) throw error;
      return data || [];
    },
    refetchInterval: 5000,
  });

  const pendentes = services.filter((s: any) => s.status === 'pendente').length;
  const emAndamento = services.filter((s: any) => s.status === 'em_andamento').length;
  const concluidos = services.filter((s: any) => s.status === 'concluido').length;

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-blue-900 to-slate-900 p-8">
      <MonitorAudioControls context="services" onSpeedChange={setSlideSpeed} />
      <div className="max-w-7xl mx-auto">
        <div className="mb-8 text-center">
          <div className="flex items-center justify-center gap-4 mb-4">
            <Wrench className="w-16 h-16 text-blue-400" />
            <h1 className="text-6xl font-bold text-white">SERVIÇOS</h1>
          </div>
          <p className="text-2xl text-slate-300">
            {format(new Date(), "dd 'de' MMMM 'de' yyyy - HH:mm", { locale: ptBR })}
          </p>
          <div className="flex justify-center gap-6 mt-6">
            <div className="bg-yellow-500/20 rounded-lg px-6 py-3 border border-yellow-500">
              <p className="text-yellow-300">Pendentes: {pendentes}</p>
            </div>
            <div className="bg-blue-500/20 rounded-lg px-6 py-3 border border-blue-500">
              <p className="text-blue-300">Em Andamento: {emAndamento}</p>
            </div>
            <div className="bg-green-500/20 rounded-lg px-6 py-3 border border-green-500">
              <p className="text-green-300">Concluídos: {concluidos}</p>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {services.map((service: any) => (
            <Card key={service.id} className="bg-gradient-to-br from-blue-900 to-cyan-900 border-2 border-blue-600 shadow-2xl">
              <CardContent className="pt-6">
                <div className="text-center">
                  <Wrench className="w-12 h-12 mx-auto mb-4 text-blue-300" />
                  <h3 className="text-xl font-bold text-white mb-2">{service.service_type}</h3>
                  <p className="text-blue-200 mb-3">{service.customer_name}</p>
                  <div className="bg-black/30 rounded-lg p-3 mb-3">
                    <p className="text-2xl font-bold text-white">R$ {service.total_value?.toFixed(2)}</p>
                  </div>
                  {service.employee_name && (
                    <p className="text-blue-300 text-sm mb-2">{service.employee_name}</p>
                  )}
                  <Badge className={`${
                    service.status === 'pendente' ? 'bg-yellow-500' :
                    service.status === 'em_andamento' ? 'bg-blue-500' : 'bg-green-500'
                  }`}>
                    {service.status === 'pendente' ? 'Pendente' :
                     service.status === 'em_andamento' ? 'Em Andamento' : 'Concluído'}
                  </Badge>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </div>
  );
}
