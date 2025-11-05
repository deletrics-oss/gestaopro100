-- Criar tabela para armazenar configurações de áudio por usuário
CREATE TABLE public.audio_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  alert_mode TEXT NOT NULL DEFAULT 'on-order',
  audio_source TEXT NOT NULL DEFAULT 'server',
  selected_sounds JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Habilitar RLS
ALTER TABLE public.audio_settings ENABLE ROW LEVEL SECURITY;

-- Policies para audio_settings
CREATE POLICY "Usuários podem ver suas próprias configurações"
ON public.audio_settings FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem inserir suas próprias configurações"
ON public.audio_settings FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem atualizar suas próprias configurações"
ON public.audio_settings FOR UPDATE
USING (auth.uid() = user_id);

-- Trigger para atualizar updated_at
CREATE TRIGGER update_audio_settings_updated_at
  BEFORE UPDATE ON public.audio_settings
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();