
-- Migration: 20251031045212

-- Migration: 20251031031925

-- Migration: 20251030045307
-- Tabela de Clientes
CREATE TABLE public.customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  cpf_cnpj TEXT,
  address TEXT,
  city TEXT,
  state TEXT,
  zip_code TEXT,
  birth_date DATE,
  notes TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Fornecedores
CREATE TABLE public.suppliers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  contact_person TEXT,
  email TEXT,
  phone TEXT,
  cnpj TEXT,
  address TEXT,
  city TEXT,
  state TEXT,
  zip_code TEXT,
  notes TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Funcionários
CREATE TABLE public.employees (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  role TEXT,
  email TEXT,
  phone TEXT,
  cpf TEXT,
  hire_date DATE,
  salary DECIMAL(10,2),
  birth_date DATE,
  address TEXT,
  city TEXT,
  state TEXT,
  zip_code TEXT,
  active BOOLEAN DEFAULT true,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Produtos
CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  sku TEXT,
  description TEXT,
  category TEXT,
  unit_price DECIMAL(10,2) NOT NULL DEFAULT 0,
  cost_price DECIMAL(10,2) NOT NULL DEFAULT 0,
  stock_quantity INTEGER NOT NULL DEFAULT 0,
  minimum_stock INTEGER DEFAULT 0,
  location TEXT,
  supplier_id UUID REFERENCES public.suppliers(id),
  active BOOLEAN DEFAULT true,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Materiais (Matéria-prima)
CREATE TABLE public.materials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  material_name TEXT NOT NULL,
  description TEXT,
  unit TEXT NOT NULL DEFAULT 'UN',
  quantity DECIMAL(10,2) NOT NULL DEFAULT 0,
  minimum_quantity DECIMAL(10,2) DEFAULT 0,
  unit_price DECIMAL(10,2) DEFAULT 0,
  supplier_id UUID REFERENCES public.suppliers(id),
  location TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Vendas
CREATE TABLE public.sales (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID REFERENCES public.customers(id),
  customer_name TEXT,
  product_id UUID REFERENCES public.products(id),
  product_name TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL,
  total_revenue DECIMAL(10,2) NOT NULL,
  cost_price DECIMAL(10,2) DEFAULT 0,
  total_cost DECIMAL(10,2) DEFAULT 0,
  profit DECIMAL(10,2) DEFAULT 0,
  sale_date DATE NOT NULL DEFAULT CURRENT_DATE,
  payment_method TEXT,
  notes TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Serviços
CREATE TABLE public.services (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID REFERENCES public.customers(id),
  customer_name TEXT NOT NULL,
  service_type TEXT NOT NULL,
  description TEXT,
  total_value DECIMAL(10,2) NOT NULL,
  cost DECIMAL(10,2) DEFAULT 0,
  profit DECIMAL(10,2) DEFAULT 0,
  service_date DATE NOT NULL DEFAULT CURRENT_DATE,
  status TEXT DEFAULT 'pendente',
  employee_id UUID REFERENCES public.employees(id),
  employee_name TEXT,
  payment_method TEXT,
  notes TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Despesas
CREATE TABLE public.expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  value DECIMAL(10,2) NOT NULL,
  expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
  payment_method TEXT,
  supplier_id UUID REFERENCES public.suppliers(id),
  supplier_name TEXT,
  due_date DATE,
  paid BOOLEAN DEFAULT false,
  notes TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Pedidos Marketplace
CREATE TABLE public.marketplace_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number TEXT NOT NULL,
  customer_name TEXT NOT NULL,
  items JSONB NOT NULL DEFAULT '[]',
  status TEXT NOT NULL DEFAULT 'pendente',
  integration TEXT DEFAULT 'manual',
  completed_by TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Ordens de Produção
CREATE TABLE public.production_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number TEXT NOT NULL,
  product_id UUID REFERENCES public.products(id),
  product_name TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'pendente',
  priority TEXT DEFAULT 'normal',
  start_date TIMESTAMP WITH TIME ZONE,
  end_date TIMESTAMP WITH TIME ZONE,
  employee_id UUID REFERENCES public.employees(id),
  employee_name TEXT,
  notes TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Máquinas e Veículos
CREATE TABLE public.machines_vehicles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  brand TEXT,
  model TEXT,
  serial_number TEXT,
  purchase_date DATE,
  purchase_value DECIMAL(10,2),
  status TEXT DEFAULT 'ativo',
  last_maintenance DATE,
  next_maintenance DATE,
  location TEXT,
  notes TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Notas Fiscais
CREATE TABLE public.invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_number TEXT NOT NULL,
  type TEXT NOT NULL,
  customer_id UUID REFERENCES public.customers(id),
  customer_name TEXT,
  supplier_id UUID REFERENCES public.suppliers(id),
  supplier_name TEXT,
  total_value DECIMAL(10,2) NOT NULL,
  tax_value DECIMAL(10,2) DEFAULT 0,
  issue_date DATE NOT NULL DEFAULT CURRENT_DATE,
  due_date DATE,
  status TEXT DEFAULT 'emitida',
  payment_method TEXT,
  notes TEXT,
  created_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_date TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Habilitar RLS em todas as tabelas
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.marketplace_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.production_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.machines_vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;

-- Políticas RLS: Por enquanto, permitir acesso a usuários autenticados
CREATE POLICY "Authenticated users can view customers" ON public.customers FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert customers" ON public.customers FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update customers" ON public.customers FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete customers" ON public.customers FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view suppliers" ON public.suppliers FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert suppliers" ON public.suppliers FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update suppliers" ON public.suppliers FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete suppliers" ON public.suppliers FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view employees" ON public.employees FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert employees" ON public.employees FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update employees" ON public.employees FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete employees" ON public.employees FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view products" ON public.products FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert products" ON public.products FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update products" ON public.products FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete products" ON public.products FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view materials" ON public.materials FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert materials" ON public.materials FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update materials" ON public.materials FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete materials" ON public.materials FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view sales" ON public.sales FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert sales" ON public.sales FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update sales" ON public.sales FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete sales" ON public.sales FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view services" ON public.services FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert services" ON public.services FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update services" ON public.services FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete services" ON public.services FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view expenses" ON public.expenses FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert expenses" ON public.expenses FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update expenses" ON public.expenses FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete expenses" ON public.expenses FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view marketplace_orders" ON public.marketplace_orders FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert marketplace_orders" ON public.marketplace_orders FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update marketplace_orders" ON public.marketplace_orders FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete marketplace_orders" ON public.marketplace_orders FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view production_orders" ON public.production_orders FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert production_orders" ON public.production_orders FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update production_orders" ON public.production_orders FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete production_orders" ON public.production_orders FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view machines_vehicles" ON public.machines_vehicles FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert machines_vehicles" ON public.machines_vehicles FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update machines_vehicles" ON public.machines_vehicles FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete machines_vehicles" ON public.machines_vehicles FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can view invoices" ON public.invoices FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert invoices" ON public.invoices FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update invoices" ON public.invoices FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete invoices" ON public.invoices FOR DELETE TO authenticated USING (true);

-- Função para atualizar updated_date automaticamente
CREATE OR REPLACE FUNCTION public.update_updated_date()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_date = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_date
CREATE TRIGGER update_customers_updated_date BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_suppliers_updated_date BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_employees_updated_date BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_products_updated_date BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_materials_updated_date BEFORE UPDATE ON public.materials FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_sales_updated_date BEFORE UPDATE ON public.sales FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_services_updated_date BEFORE UPDATE ON public.services FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_expenses_updated_date BEFORE UPDATE ON public.expenses FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_marketplace_orders_updated_date BEFORE UPDATE ON public.marketplace_orders FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_production_orders_updated_date BEFORE UPDATE ON public.production_orders FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_machines_vehicles_updated_date BEFORE UPDATE ON public.machines_vehicles FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_invoices_updated_date BEFORE UPDATE ON public.invoices FOR EACH ROW EXECUTE FUNCTION update_updated_date();

-- Migration: 20251030045344
-- Corrigir search_path na função update_updated_date
DROP FUNCTION IF EXISTS public.update_updated_date() CASCADE;

CREATE OR REPLACE FUNCTION public.update_updated_date()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  NEW.updated_date = now();
  RETURN NEW;
END;
$$;

-- Recriar triggers para updated_date
CREATE TRIGGER update_customers_updated_date BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_suppliers_updated_date BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_employees_updated_date BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_products_updated_date BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_materials_updated_date BEFORE UPDATE ON public.materials FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_sales_updated_date BEFORE UPDATE ON public.sales FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_services_updated_date BEFORE UPDATE ON public.services FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_expenses_updated_date BEFORE UPDATE ON public.expenses FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_marketplace_orders_updated_date BEFORE UPDATE ON public.marketplace_orders FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_production_orders_updated_date BEFORE UPDATE ON public.production_orders FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_machines_vehicles_updated_date BEFORE UPDATE ON public.machines_vehicles FOR EACH ROW EXECUTE FUNCTION update_updated_date();
CREATE TRIGGER update_invoices_updated_date BEFORE UPDATE ON public.invoices FOR EACH ROW EXECUTE FUNCTION update_updated_date();


-- Migration: 20251031032836
-- Criar tabelas necessárias para o sistema de gestão

-- Tabela de clientes
CREATE TABLE IF NOT EXISTS public.customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de fornecedores
CREATE TABLE IF NOT EXISTS public.suppliers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  address TEXT,
  cnpj TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de funcionários
CREATE TABLE IF NOT EXISTS public.employees (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  role TEXT,
  salary DECIMAL(10, 2),
  hire_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de produtos
CREATE TABLE IF NOT EXISTS public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_name TEXT NOT NULL,
  variation_name TEXT,
  sale_price DECIMAL(10, 2),
  cost_price DECIMAL(10, 2),
  stock_quantity INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de vendas
CREATE TABLE IF NOT EXISTS public.sales (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_name TEXT NOT NULL,
  customer_id UUID REFERENCES public.customers(id),
  quantity INTEGER NOT NULL,
  total_revenue DECIMAL(10, 2) NOT NULL,
  payment_method TEXT,
  sale_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de despesas
CREATE TABLE IF NOT EXISTS public.expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  description TEXT NOT NULL,
  value DECIMAL(10, 2) NOT NULL,
  category TEXT,
  supplier_id UUID REFERENCES public.suppliers(id),
  expense_date DATE DEFAULT CURRENT_DATE,
  payment_method TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de notas fiscais
CREATE TABLE IF NOT EXISTS public.invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_number TEXT NOT NULL,
  customer_id UUID REFERENCES public.customers(id),
  supplier_id UUID REFERENCES public.suppliers(id),
  amount DECIMAL(10, 2) NOT NULL,
  issue_date DATE DEFAULT CURRENT_DATE,
  status TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de pedidos marketplace
CREATE TABLE IF NOT EXISTS public.marketplace_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number TEXT NOT NULL,
  marketplace TEXT NOT NULL,
  customer_name TEXT,
  total_value DECIMAL(10, 2) NOT NULL,
  status TEXT,
  order_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de ordens de produção
CREATE TABLE IF NOT EXISTS public.production_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID REFERENCES public.products(id),
  quantity INTEGER NOT NULL,
  status TEXT,
  employee_id UUID REFERENCES public.employees(id),
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de máquinas e veículos
CREATE TABLE IF NOT EXISTS public.machines_vehicles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  type TEXT,
  acquisition_date DATE,
  maintenance_date DATE,
  status TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Habilitar RLS em todas as tabelas
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.marketplace_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.production_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.machines_vehicles ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para permitir acesso autenticado
CREATE POLICY "Usuários autenticados podem ver customers" ON public.customers FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem inserir customers" ON public.customers FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários autenticados podem atualizar customers" ON public.customers FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem deletar customers" ON public.customers FOR DELETE TO authenticated USING (true);

CREATE POLICY "Usuários autenticados podem ver suppliers" ON public.suppliers FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem inserir suppliers" ON public.suppliers FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários autenticados podem atualizar suppliers" ON public.suppliers FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem deletar suppliers" ON public.suppliers FOR DELETE TO authenticated USING (true);

CREATE POLICY "Usuários autenticados podem ver employees" ON public.employees FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem inserir employees" ON public.employees FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários autenticados podem atualizar employees" ON public.employees FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem deletar employees" ON public.employees FOR DELETE TO authenticated USING (true);

CREATE POLICY "Usuários autenticados podem ver products" ON public.products FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem inserir products" ON public.products FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários autenticados podem atualizar products" ON public.products FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem deletar products" ON public.products FOR DELETE TO authenticated USING (true);

CREATE POLICY "Usuários autenticados podem ver sales" ON public.sales FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem inserir sales" ON public.sales FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários autenticados podem atualizar sales" ON public.sales FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem deletar sales" ON public.sales FOR DELETE TO authenticated USING (true);

CREATE POLICY "Usuários autenticados podem ver expenses" ON public.expenses FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem inserir expenses" ON public.expenses FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários autenticados podem atualizar expenses" ON public.expenses FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem deletar expenses" ON public.expenses FOR DELETE TO authenticated USING (true);

CREATE POLICY "Usuários autenticados podem ver invoices" ON public.invoices FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem inserir invoices" ON public.invoices FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários autenticados podem atualizar invoices" ON public.invoices FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem deletar invoices" ON public.invoices FOR DELETE TO authenticated USING (true);

CREATE POLICY "Usuários autenticados podem ver marketplace_orders" ON public.marketplace_orders FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem inserir marketplace_orders" ON public.marketplace_orders FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários autenticados podem atualizar marketplace_orders" ON public.marketplace_orders FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem deletar marketplace_orders" ON public.marketplace_orders FOR DELETE TO authenticated USING (true);

CREATE POLICY "Usuários autenticados podem ver production_orders" ON public.production_orders FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem inserir production_orders" ON public.production_orders FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários autenticados podem atualizar production_orders" ON public.production_orders FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem deletar production_orders" ON public.production_orders FOR DELETE TO authenticated USING (true);

CREATE POLICY "Usuários autenticados podem ver machines_vehicles" ON public.machines_vehicles FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem inserir machines_vehicles" ON public.machines_vehicles FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários autenticados podem atualizar machines_vehicles" ON public.machines_vehicles FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Usuários autenticados podem deletar machines_vehicles" ON public.machines_vehicles FOR DELETE TO authenticated USING (true);

-- Trigger para atualizar updated_at
CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION public.update_updated_date();
CREATE TRIGGER update_suppliers_updated_at BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.update_updated_date();
CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.update_updated_date();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_date();
CREATE TRIGGER update_sales_updated_at BEFORE UPDATE ON public.sales FOR EACH ROW EXECUTE FUNCTION public.update_updated_date();
CREATE TRIGGER update_expenses_updated_at BEFORE UPDATE ON public.expenses FOR EACH ROW EXECUTE FUNCTION public.update_updated_date();
CREATE TRIGGER update_invoices_updated_at BEFORE UPDATE ON public.invoices FOR EACH ROW EXECUTE FUNCTION public.update_updated_date();
CREATE TRIGGER update_marketplace_orders_updated_at BEFORE UPDATE ON public.marketplace_orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_date();
CREATE TRIGGER update_production_orders_updated_at BEFORE UPDATE ON public.production_orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_date();
CREATE TRIGGER update_machines_vehicles_updated_at BEFORE UPDATE ON public.machines_vehicles FOR EACH ROW EXECUTE FUNCTION public.update_updated_date();


-- Migration: 20251101025436
CREATE TABLE IF NOT EXISTS public.usuarios (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  nome text NOT NULL,
  email text UNIQUE NOT NULL,
  tipo text DEFAULT 'Usuário',
  permissoes jsonb DEFAULT '{}',
  ativo boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY "Authenticated users can view usuarios" ON public.usuarios FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert usuarios" ON public.usuarios FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update usuarios" ON public.usuarios FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete usuarios" ON public.usuarios FOR DELETE USING (auth.role() = 'authenticated');

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_usuarios_updated_at BEFORE UPDATE ON public.usuarios FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- Migration: 20251101033324
-- Criar user_roles table separada para segurança
CREATE TYPE public.app_role AS ENUM ('admin', 'gerente', 'usuario');

CREATE TABLE IF NOT EXISTS public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  role app_role NOT NULL DEFAULT 'usuario',
  permissions JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE (user_id)
);

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

-- Função security definer para checar role
CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role app_role)
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_roles
    WHERE user_id = _user_id AND role = _role
  )
$$;

-- Função security definer para checar permissões
CREATE OR REPLACE FUNCTION public.has_permission(_user_id UUID, _permission TEXT)
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_roles
    WHERE user_id = _user_id AND (permissions->>_permission)::boolean = true
  )
$$;

-- RLS policies para user_roles
CREATE POLICY "Usuários podem ver seu próprio role"
ON public.user_roles
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Admins podem ver todos os roles"
ON public.user_roles
FOR SELECT
USING (public.has_role(auth.uid(), 'admin'));

CREATE POLICY "Admins podem gerenciar roles"
ON public.user_roles
FOR ALL
USING (public.has_role(auth.uid(), 'admin'));

-- Trigger para criar user_role automaticamente ao criar usuário na tabela usuarios
CREATE OR REPLACE FUNCTION public.sync_user_role()
RETURNS TRIGGER
LANGUAGE PLPGSQL
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Inserir ou atualizar role quando usuário é criado/atualizado
  INSERT INTO public.user_roles (user_id, role, permissions)
  VALUES (
    (SELECT id FROM auth.users WHERE email = NEW.email LIMIT 1),
    CASE 
      WHEN NEW.tipo = 'Administrador' THEN 'admin'::app_role
      WHEN NEW.tipo = 'Gerente' THEN 'gerente'::app_role
      ELSE 'usuario'::app_role
    END,
    NEW.permissoes
  )
  ON CONFLICT (user_id) DO UPDATE
  SET role = CASE 
      WHEN NEW.tipo = 'Administrador' THEN 'admin'::app_role
      WHEN NEW.tipo = 'Gerente' THEN 'gerente'::app_role
      ELSE 'usuario'::app_role
    END,
    permissions = NEW.permissoes;
  
  RETURN NEW;
END;
$$;

CREATE TRIGGER sync_user_role_trigger
AFTER INSERT OR UPDATE ON public.usuarios
FOR EACH ROW
EXECUTE FUNCTION public.sync_user_role();

-- Migration: 20251104024356

-- Criar trigger para sincronizar tabela usuarios com user_roles
CREATE OR REPLACE TRIGGER sync_usuarios_to_user_roles
  AFTER INSERT OR UPDATE ON public.usuarios
  FOR EACH ROW
  EXECUTE FUNCTION public.sync_user_role();
  
-- Comentário: Este trigger garante que toda vez que um usuário é criado ou atualizado
-- na tabela usuarios, uma entrada correspondente é criada/atualizada em user_roles
;
