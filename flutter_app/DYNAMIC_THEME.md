# Sistema de Tema Dinâmico por Cliente

## Visão Geral

Este sistema permite que a aplicação exiba diferentes temas (cores, estilos) baseado no domínio do cliente que está acessando. Por exemplo:

- `devnology.com:8000` → **Verde**
- `in8.com:8000` → **Roxo**
- `localhost` → **Roxo padrão (desenvolvimento)**

## Arquivos Principais

### 1. `lib/core/theme/brand_theme.dart`
Define o mapeamento de domínios para cores e cria os temas.

**Como adicionar um novo cliente:**

```dart
static const Map<String, Color> _domainColors = {
  'devnology.com': Color(0xFF2E7D32),   // Verde
  'in8.com': Color(0xFF6A1B9A),         // Roxo
  'seucliente.com': Color(0xFFXXXXXX),  // Sua cor aqui
};
```

E adicione o nome no mapa `clientNames`:

```dart
const Map<String, String> clientNames = {
  'devnology.com': 'Devnology',
  'in8.com': 'IN8',
  'seucliente.com': 'Seu Cliente',
};
```

### 2. `lib/core/theme/theme_provider.dart`
Gerencia o tema dinâmico usando `ChangeNotifier` (padrão Provider).

**Uso em widgets:**

```dart
// Ler o tema atual
Consumer<ThemeProvider>(
  builder: (context, themeProvider, _) {
    return Text('Cliente: ${themeProvider.clientName}');
  },
)

// Atualizar domínio (ex: após login ou detecção automática)
context.read<ThemeProvider>().updateDomain('novo-dominio.com');
```

### 3. `lib/core/config/domain_detector.dart`
Detecta automaticamente o domínio quando a app roda em navegador web.

**Uso:**

```dart
import 'core/config/domain_detector.dart';

void main() {
  final currentDomain = DomainDetector.getCurrentDomain();
  final baseUrl = DomainDetector.getApiBaseUrl();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(initialDomain: currentDomain),
      child: const MyApp(),
    ),
  );
}
```

## Integração com API

Para usar o domínio automaticamente na configuração da API:

```dart
// lib/core/network/api_client.dart
import '../config/domain_detector.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    final baseUrl = DomainDetector.getApiBaseUrl();
    
    _dio = Dio(
      BaseOptions(
        baseUrl: '$baseUrl:3000', // Ou a porta da sua API
        // ... resto da configuração
      ),
    );
  }
}
```

## Teste Local

Para simular diferentes clientes localmente, você pode:

1. **Editar o arquivo `hosts`** do seu sistema:
   - **Windows**: `C:\Windows\System32\drivers\etc\hosts`
   - Adicione:
     ```
     127.0.0.1 devnology.local
     127.0.0.1 in8.local
     ```

2. **Ou usar a HomePage de teste** (já implementada):
   - Clique nos botões "Devnology (Verde)" ou "IN8 (Roxo)" para mudar o tema

## Estrutura de Cores

### Recomendações
- Use cores vibrantes e distintivas para cada cliente
- Mantenha contraste suficiente para acessibilidade (WCAG)
- Teste em diferentes dispositivos e condições de iluminação

### Exemplos de cores por segmento:

| Cliente | Cor | Código Hex | Uso |
|---------|-----|-----------|-----|
| Devnology | Verde | `#2E7D32` | Tech/Inovação |
| IN8 | Roxo | `#6A1B9A` | Premium/Elegância |
| Default | Deep Purple | `#7B1FA2` | Desenvolvimento |

## Próximas Melhorias

1. **Carregamento de logo por cliente**
   - Armazenar logos em `assets/clients/` e carregá-los dinamicamente

2. **Fontes customizadas por cliente**
   - Adicionar mapeamento de fontes no `BrandTheme`

3. **Tema escuro/claro**
   - Implementar `darkTheme` com cores ajustadas

4. **Sincronização com Backend**
   - Buscar cores/configs da API em vez de hardcodificar

5. **Persistência**
   - Armazenar preferência de tema em `SharedPreferences`

## Troubleshooting

**O tema não muda?**
- Verifique se o domínio está mapeado em `_domainColors`
- Use `flutter run -d chrome` com `--enable-impeller` se tiver problemas gráficos

**A app carrega lentamente?**
- Reduza o delay no `SplashPage` (atualmente 2 segundos)
- Implemente a inicialização real (DI, chamadas de API)

**Cores diferentes em diferentes dispositivos?**
- Isso é normal devido a diferenças em calibração/gamut
- Considere usar cores web-safe se máxima compatibilidade for crítica
