import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Download, Upload, AlertCircle } from "lucide-react";
import { toast } from "sonner";
import { exportFullSystemBackup, importFullSystemBackup } from "@/utils/fullSystemBackup";

export function SystemBackup() {
  const [importing, setImporting] = useState(false);
  const [exporting, setExporting] = useState(false);

  const handleExport = async () => {
    setExporting(true);
    try {
      const csvContent = await exportFullSystemBackup();
      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = `backup_gestao_pro_${new Date().toISOString().split('T')[0]}.csv`;
      link.click();
      URL.revokeObjectURL(url);
      toast.success("Backup exportado com sucesso!");
    } catch (error) {
      console.error('Erro ao exportar:', error);
      toast.error("Erro ao exportar backup");
    } finally {
      setExporting(false);
    }
  };

  const handleImport = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    setImporting(true);
    try {
      const text = await file.text();
      await importFullSystemBackup(text);
      toast.success("Backup restaurado com sucesso!");
    } catch (error) {
      console.error('Erro ao importar:', error);
      toast.error("Erro ao restaurar backup");
    } finally {
      setImporting(false);
      event.target.value = '';
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <AlertCircle className="w-5 h-5" />
          Backup do Sistema
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="bg-muted p-4 rounded-lg">
          <p className="text-sm text-muted-foreground">
            Faça backup completo de todos os dados do sistema ou restaure um backup anterior.
            O backup inclui: Produtos, Vendas, Clientes, Fornecedores, Despesas, Serviços, Materiais, Funcionários, Máquinas, Ordens de Produção e Pedidos Marketplace.
          </p>
        </div>
        
        <div className="flex gap-4">
          <Button 
            onClick={handleExport} 
            disabled={exporting}
            className="flex-1"
          >
            <Download className="w-4 h-4 mr-2" />
            {exporting ? 'Exportando...' : 'Exportar Backup'}
          </Button>
          
          <Button 
            variant="outline"
            disabled={importing}
            className="flex-1"
            onClick={() => document.getElementById('import-backup')?.click()}
          >
            <Upload className="w-4 h-4 mr-2" />
            {importing ? 'Importando...' : 'Restaurar Backup'}
          </Button>
          <input
            id="import-backup"
            type="file"
            accept=".csv"
            onChange={handleImport}
            className="hidden"
          />
        </div>

        <div className="bg-yellow-500/10 border border-yellow-500/20 rounded-lg p-4">
          <p className="text-sm text-yellow-600 dark:text-yellow-400 font-medium">
            ⚠️ Aviso: Ao restaurar um backup, os dados existentes serão mantidos e os novos dados do backup serão adicionados ao sistema.
          </p>
        </div>
      </CardContent>
    </Card>
  );
}
