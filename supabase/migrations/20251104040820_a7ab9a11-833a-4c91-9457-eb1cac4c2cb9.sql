-- Criar tabela para componentes de produtos
CREATE TABLE IF NOT EXISTS public.product_components (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  cost NUMERIC NOT NULL DEFAULT 0,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.product_components ENABLE ROW LEVEL SECURITY;

-- Políticas RLS
CREATE POLICY "Authenticated users can view product_components" 
ON public.product_components 
FOR SELECT 
USING (true);

CREATE POLICY "Authenticated users can insert product_components" 
ON public.product_components 
FOR INSERT 
WITH CHECK (true);

CREATE POLICY "Authenticated users can update product_components" 
ON public.product_components 
FOR UPDATE 
USING (true);

CREATE POLICY "Authenticated users can delete product_components" 
ON public.product_components 
FOR DELETE 
USING (true);

-- Trigger para updated_date
CREATE TRIGGER update_product_components_updated_date
BEFORE UPDATE ON public.product_components
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();