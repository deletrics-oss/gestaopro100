import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Trash2, Plus } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

interface ProductComponent {
  id?: string;
  name: string;
  description: string;
  cost: number;
}

interface ProductComponentsManagerProps {
  components: ProductComponent[];
  onChange: (components: ProductComponent[]) => void;
}

export function ProductComponentsManager({ components, onChange }: ProductComponentsManagerProps) {
  const [newComponent, setNewComponent] = useState<ProductComponent>({
    name: "",
    description: "",
    cost: 0,
  });

  const handleAddComponent = () => {
    if (!newComponent.name || newComponent.cost <= 0) {
      return;
    }
    onChange([...components, { ...newComponent, id: crypto.randomUUID() }]);
    setNewComponent({ name: "", description: "", cost: 0 });
  };

  const handleRemoveComponent = (index: number) => {
    onChange(components.filter((_, i) => i !== index));
  };

  const totalComponentCost = components.reduce((sum, comp) => sum + Number(comp.cost), 0);

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-lg">Componentes do Produto</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        {/* Lista de componentes */}
        <div className="space-y-2">
          {components.map((component, index) => (
            <div key={index} className="flex items-center gap-2 p-3 border rounded-lg bg-muted/50">
              <div className="flex-1">
                <p className="font-medium">{component.name}</p>
                <p className="text-xs text-muted-foreground">{component.description}</p>
              </div>
              <div className="text-right">
                <p className="font-semibold">R$ {Number(component.cost).toFixed(2)}</p>
              </div>
              <Button
                type="button"
                size="icon"
                variant="ghost"
                onClick={() => handleRemoveComponent(index)}
              >
                <Trash2 className="h-4 w-4 text-destructive" />
              </Button>
            </div>
          ))}
        </div>

        {/* Total */}
        {components.length > 0 && (
          <div className="p-3 bg-primary/10 rounded-lg">
            <div className="flex justify-between items-center">
              <span className="font-semibold">Total dos Componentes:</span>
              <span className="text-lg font-bold">R$ {totalComponentCost.toFixed(2)}</span>
            </div>
          </div>
        )}

        {/* Form para adicionar novo componente */}
        <div className="border-t pt-4">
          <h4 className="font-semibold mb-3">Adicionar Componente</h4>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
            <div>
              <Label htmlFor="comp-name">Nome</Label>
              <Input
                id="comp-name"
                placeholder="Ex: Material"
                value={newComponent.name}
                onChange={(e) => setNewComponent({ ...newComponent, name: e.target.value })}
              />
            </div>
            <div>
              <Label htmlFor="comp-description">Descrição</Label>
              <Input
                id="comp-description"
                placeholder="Ex: Chapa de aço"
                value={newComponent.description}
                onChange={(e) => setNewComponent({ ...newComponent, description: e.target.value })}
              />
            </div>
            <div>
              <Label htmlFor="comp-cost">Custo (R$)</Label>
              <Input
                id="comp-cost"
                type="number"
                step="0.01"
                placeholder="0.00"
                value={newComponent.cost || ""}
                onChange={(e) => setNewComponent({ ...newComponent, cost: Number(e.target.value) })}
              />
            </div>
          </div>
          <Button
            type="button"
            className="mt-3 gap-2"
            onClick={handleAddComponent}
            disabled={!newComponent.name || newComponent.cost <= 0}
          >
            <Plus className="h-4 w-4" />
            Adicionar Componente
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
