-- Create Enums for fixed values
CREATE TYPE rank_enum AS ENUM (
  'Oficial II', 
  'Oficial III', 
  'Oficial III+', 
  'Detective I', 
  'Detective II', 
  'Detective III', 
  'Teniente', 
  'Capitan'
);

CREATE TYPE role_enum AS ENUM (
  'Ayudante', 
  'Detective', 
  'Coordinador', 
  'Jefatura', 
  'Administrador'
);

-- Create Profiles table (extends default auth.users)
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  badge_number TEXT UNIQUE NOT NULL,
  rank rank_enum NOT NULL DEFAULT 'Detective I',
  role role_enum NOT NULL DEFAULT 'Detective',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (Security best practice)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can read profiles (for checking names/badges)
CREATE POLICY "Public profiles are viewable by everyone" 
ON public.profiles FOR SELECT 
USING (true);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update own profile" 
ON public.profiles FOR UPDATE 
USING (auth.uid() = id);

-- Function to handle new user creation automatically
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username, first_name, last_name, badge_number)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'username',
    NEW.raw_user_meta_data->>'first_name',
    NEW.raw_user_meta_data->>'last_name',
    NEW.raw_user_meta_data->>'badge_number'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to run the function when a user signs up via Auth
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
