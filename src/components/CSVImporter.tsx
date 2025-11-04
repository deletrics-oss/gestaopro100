import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Upload, FileText } from "lucide-react";
import { importProductsFromCSV, importCustomersFromCSV } from "@/utils/csvImporter";
import { toast } from "sonner";

interface CSVImporterProps {
  type: 'products' | 'customers';
  onSuccess?: () => void;
}

export function CSVImporter({ type, onSuccess }: CSVImporterProps) {
  const [file, setFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setFile(e.target.files[0]);
    }
  };

  const handleImport = async () => {
    if (!file) {
      toast.error("Selecione um arquivo CSV");
      return;
    }

    setImporting(true);
    try {
      const text = await file.text();
      
      if (type === 'products') {
        await importProductsFromCSV(text);
      } else {
        await importCustomersFromCSV(text);
      }
      
      setFile(null);
      onSuccess?.();
    } catch (error: any) {
      console.error('Erro na importação:', error);
      toast.error(`Erro ao importar: ${error.message}`);
    } finally {
      setImporting(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Upload className="h-5 w-5" />
          Importar {type === 'products' ? 'Produtos' : 'Clientes'} do CSV
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div>
          <Label htmlFor="csv-file">Arquivo CSV</Label>
          <Input
            id="csv-file"
            type="file"
            accept=".csv"
            onChange={handleFileChange}
            disabled={importing}
          />
          {file && (
            <p className="text-sm text-muted-foreground mt-2 flex items-center gap-2">
              <FileText className="h-4 w-4" />
              {file.name}
            </p>
          )}
        </div>
        <Button 
          onClick={handleImport} 
          disabled={!file || importing}
          className="w-full"
        >
          {importing ? 'Importando...' : 'Importar Dados'}
        </Button>
      </CardContent>
    </Card>
  );
}
