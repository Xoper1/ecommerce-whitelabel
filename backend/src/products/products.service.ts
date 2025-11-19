import { Injectable } from '@nestjs/common';
import { ProvidersService, NormalizedProduct } from '../providers/providers.service';
import { Client } from '../clients/client.entity';
import { ProductFilterDto } from './dto/product-filter.dto';

@Injectable()
export class ProductsService {
  constructor(private providersService: ProvidersService) {}

  async findAll(client: Client, filters: ProductFilterDto): Promise<NormalizedProduct[]> {
    // Get active provider configs for this client
    const activeProviders = client.provider_configs
      .filter(config => config.is_active)
      .sort((a, b) => a.priority - b.priority);

    // Fetch products from all active providers
    const productPromises = activeProviders.map(async (config) => {
      if (config.provider_name === 'brazilian') {
        return this.providersService.fetchBrazilianProducts();
      } else if (config.provider_name === 'european') {
        return this.providersService.fetchEuropeanProducts();
      }
      return [];
    });

    const productsArrays = await Promise.all(productPromises);
    let products = productsArrays.flat();

    // Apply filters
    if (filters.search) {
      const searchLower = filters.search.toLowerCase();
      products = products.filter(p =>
        p.name.toLowerCase().includes(searchLower) ||
        p.description.toLowerCase().includes(searchLower)
      );
    }

    if (filters.category) {
      const categoryLower = filters.category.toLowerCase();
      products = products.filter(p =>
        p.category.toLowerCase().includes(categoryLower)
      );
    }

    if (filters.minPrice !== undefined) {
      products = products.filter(p => p.price >= filters.minPrice);
    }

    if (filters.maxPrice !== undefined) {
      products = products.filter(p => p.price <= filters.maxPrice);
    }

    return products;
  }

  async findOne(client: Client, id: string): Promise<NormalizedProduct | null> {
    // Parse provider from ID prefix (br_ or eu_)
    const [provider, productId] = id.split('_');

    // Check if this provider is active for the client
    const providerConfig = client.provider_configs.find(
      config =>
        config.is_active &&
        ((provider === 'br' && config.provider_name === 'brazilian') ||
          (provider === 'eu' && config.provider_name === 'european'))
    );

    if (!providerConfig) {
      return null;
    }

    // Fetch product from the correct provider
    if (provider === 'br') {
      return this.providersService.fetchBrazilianProductById(productId);
    } else if (provider === 'eu') {
      return this.providersService.fetchEuropeanProductById(productId);
    }

    return null;
  }

  async getCategories(client: Client): Promise<string[]> {
    const products = await this.findAll(client, {});
    const categories = new Set(products.map(p => p.category));
    return Array.from(categories).sort();
  }
}
