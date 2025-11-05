-- Criar tabela separada para movimentações de caixa
CREATE TABLE IF NOT EXISTS public.cash_movements (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  type TEXT NOT NULL CHECK (type IN ('entrada', 'saida')),
  description TEXT NOT NULL,
  value NUMERIC NOT NULL,
  movement_date DATE NOT NULL DEFAULT CURRENT_DATE,
  payment_method TEXT,
  category TEXT,
  notes TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Migrar dados existentes de movimentação de caixa
INSERT INTO public.cash_movements (description, value, movement_date, payment_method, notes, created_date, updated_date)
SELECT 
  REPLACE(REPLACE(description, 'Entrada: ', ''), 'Saída: ', '') as description,
  ABS(value) as value,
  expense_date as movement_date,
  payment_method,
  notes,
  created_date,
  updated_date
FROM public.expenses
WHERE category = 'Movimentação Caixa';

-- Adicionar tipo baseado na descrição original
UPDATE public.cash_movements cm
SET type = CASE 
  WHEN EXISTS (
    SELECT 1 FROM public.expenses e 
    WHERE e.category = 'Movimentação Caixa' 
    AND e.description LIKE 'Entrada:%'
    AND ABS(e.value) = cm.value
    AND e.expense_date = cm.movement_date
  ) THEN 'entrada'
  ELSE 'saida'
END;

-- Remover movimentações de caixa da tabela de despesas
DELETE FROM public.expenses WHERE category = 'Movimentação Caixa';

-- Habilitar RLS
ALTER TABLE public.cash_movements ENABLE ROW LEVEL SECURITY;

-- Políticas RLS
CREATE POLICY "Authenticated users can view cash_movements"
ON public.cash_movements FOR SELECT
USING (true);

CREATE POLICY "Authenticated users can insert cash_movements"
ON public.cash_movements FOR INSERT
WITH CHECK (true);

CREATE POLICY "Authenticated users can update cash_movements"
ON public.cash_movements FOR UPDATE
USING (true);

CREATE POLICY "Authenticated users can delete cash_movements"
ON public.cash_movements FOR DELETE
USING (true);

-- Trigger para atualizar updated_date
CREATE TRIGGER update_cash_movements_updated_date
BEFORE UPDATE ON public.cash_movements
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();