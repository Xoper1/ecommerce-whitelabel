# Solução de Erro 404 - Produtos Não Encontrados

## 🔴 Problema

```
Erro ao buscar produtos: Exception: Network error: This exception was thrown 
because the response has a status code of 404
```

## ✅ Solução

O erro 404 significa que o **cliente "cliente1.local" não foi encontrado no banco de dados**. Você precisa:

### Passo 1: Verificar se MySQL está rodando

**Windows:**
1. Abra o **Serviços** (Services)
2. Procure por "MySQL80" (ou versão que tem instalada)
3. Se não estiver rodando, clique em "Iniciar"

Ou pelo terminal:
```powershell
# Verificar se está rodando
Get-Service | Where-Object {$_.Name -like "*MySQL*"} | Select-Object Name, Status

# Se não estiver rodando
Start-Service MySQL80  # ou a versão que tem
```

### Passo 2: Criar o banco de dados

Abra um terminal PowerShell e execute:

```powershell
# Entre na pasta do backend
cd D:\Pedro-Testes\ecommerce-whitelabel\backend

# Execute o script SQL (o banco será criado automaticamente)
# Se mysql estiver no PATH:
mysql -u root < docs/database.sql

# Se não estiver, use o caminho completo:
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql" -u root < docs/database.sql

# Se a senha estiver vazia, use:
mysql -u root --password= < docs/database.sql
```

**Se der erro de "Access denied":**
```powershell
# Tente com um usuário administrativo
mysql -u root -p
# Digite a senha (provavelmente vazia, apenas pressione Enter)

# Depois execute no MySQL:
SOURCE docs/database.sql;
EXIT;
```

### Passo 3: Verificar se os dados foram inseridos

```powershell
mysql -u root -e "USE ecommerce_whitelabel; SELECT * FROM clients;"
```

Deve mostrar:
```
+----+-----------+------------------+---+--+
| id | name      | domain           | ..| ..|
+----+-----------+------------------+---+--+
| 1  | Loja BR   | cliente1.local   | ..| ..|
| 2  | Euro Store| cliente2.local   | ..| ..|
| 3  | Multi Store| cliente3.local  | ..| ..|
+----+-----------+------------------+---+--+
```

### Passo 4: Verificar se o backend está rodando

```powershell
cd D:\Pedro-Testes\ecommerce-whitelabel\backend
npm run start:dev
```

Deve exibir algo como:
```
[Nest] 12345 - 16/11/2025, 12:00:00 LOG [NestFactory] Starting Nest application...
```

### Passo 5: Testar a API manualmente

Abra outro terminal PowerShell:

```powershell
# Teste o endpoint de produtos
curl -H "X-Client-Domain: cliente1.local" http://localhost:3000/products

# Deve retornar um JSON com produtos (pode estar vazio se os fornecedores não tiverem dados)
```

### Passo 6: Testar no Flutter

Agora clique em "Ver Produtos" no app Flutter. Deve funcionar!

## 🔧 Se ainda não funcionar

### Opção A: Usar banco de dados em Docker (mais fácil)

```powershell
# Instalar Docker (se não tiver)
# https://www.docker.com/products/docker-desktop

# Rodar MySQL em container
docker run --name mysql-ecommerce -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -d mysql:8.0

# Esperar alguns segundos, depois:
docker exec -i mysql-ecommerce mysql -u root -proot < docs/database.sql
```

### Opção B: Usar dados simulados no Flutter (apenas para testes)

Se quiser testar sem o backend real, edite `lib/data/providers/product_provider.dart`:

```dart
// Adicione este método:
static List<ProductModel> _getMockProducts() {
  return [
    ProductModel(
      id: 'mock_1',
      name: 'Camisa Polo',
      description: 'Camisa polo de alta qualidade',
      price: 127.00,
      category: 'Vestuário',
      images: ['https://via.placeholder.com/300x300?text=Camisa'],
      material: 'Algodão',
      hasDiscount: true,
      discountValue: 27.00,
      provider: 'brazilian',
    ),
    // ... adicione mais produtos aqui
  ];
}
```

E modifique `getProducts()` para retornar dados simulados:

```dart
Future<List<ProductModel>> getProducts({...}) async {
  // Retornar dados simulados para teste
  return _getMockProducts();
}
```

## 📊 Verificação Rápida

### Backend rodando?
```powershell
curl http://localhost:3000/api
# Se retornar algo, backend está rodando
```

### Banco de dados criado?
```powershell
mysql -u root -e "SHOW DATABASES;" | findstr ecommerce_whitelabel
```

### Cliente cadastrado?
```powershell
mysql -u root -e "USE ecommerce_whitelabel; SELECT domain FROM clients;"
# Deve mostrar: cliente1.local, cliente2.local, cliente3.local
```

## 🎯 Resumo

1. ✅ Verifique MySQL
2. ✅ Execute `docs/database.sql`
3. ✅ Inicie o backend com `npm run start:dev`
4. ✅ Volte para o Flutter e teste

Se tudo estiver certo, o erro desaparecerá e você verá os produtos!

---

**Dúvidas frequentes:**

**P: Não consegui executar o SQL, o que faço?**
R: Use o MySQL Workbench ou phpMyAdmin para executar o script manualmente

**P: Backend conecta mas ainda dá 404?**
R: Significa que o cliente não existe. Verifique se `cliente1.local` está na tabela `clients`

**P: Produtos aparecem mas sem imagens?**
R: Os fornecedores (API externa) podem estar fora. Use URLs de placeholder:
```dart
'images': ['https://via.placeholder.com/300x300?text=Produto']
```
