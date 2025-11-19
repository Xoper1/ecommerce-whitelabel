import { Injectable, HttpException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

export interface NormalizedProduct {
  id: string;
  name: string;
  description: string;
  price: number;
  category: string;
  images: string[];
  material: string;
  hasDiscount: boolean;
  discountValue: number;
  provider: 'brazilian' | 'european';
}

@Injectable()
export class ProvidersService {
  private brazilianProviderUrl: string;
  private europeanProviderUrl: string;

  constructor(
    private configService: ConfigService,
    private httpService: HttpService,
  ) {
    this.brazilianProviderUrl = this.configService.get('BRAZILIAN_PROVIDER_URL');
    this.europeanProviderUrl = this.configService.get('EUROPEAN_PROVIDER_URL');
  }

  async fetchBrazilianProducts(): Promise<NormalizedProduct[]> {
    try {
      const response = await firstValueFrom(
        this.httpService.get(this.brazilianProviderUrl),
      );

      return response.data.map((product: any) => this.normalizeBrazilianProduct(product));
    } catch (error) {
      console.error('Error fetching Brazilian products:', error.message);
      return [];
    }
  }

  async fetchEuropeanProducts(): Promise<NormalizedProduct[]> {
    try {
      const response = await firstValueFrom(
        this.httpService.get(this.europeanProviderUrl),
      );

      return response.data.map((product: any) => this.normalizeEuropeanProduct(product));
    } catch (error) {
      console.error('Error fetching European products:', error.message);
      return [];
    }
  }

  async fetchBrazilianProductById(id: string): Promise<NormalizedProduct | null> {
    try {
      const response = await firstValueFrom(
        this.httpService.get(`${this.brazilianProviderUrl}/${id}`),
      );

      return this.normalizeBrazilianProduct(response.data);
    } catch (error) {
      console.error('Error fetching Brazilian product by ID:', error.message);
      return null;
    }
  }

  async fetchEuropeanProductById(id: string): Promise<NormalizedProduct | null> {
    try {
      const response = await firstValueFrom(
        this.httpService.get(`${this.europeanProviderUrl}/${id}`),
      );

      return this.normalizeEuropeanProduct(response.data);
    } catch (error) {
      console.error('Error fetching European product by ID:', error.message);
      return null;
    }
  }

  private normalizeBrazilianProduct(product: any): NormalizedProduct {
    return {
      id: `br_${product.id}`,
      name: product.nome || product.name || 'Produto sem nome',
      description: product.descricao || product.description || '',
      price: parseFloat(product.preco) || 0,
      category: product.categoria || product.departamento || 'Geral',
      images: product.imagem ? [product.imagem] : [],
      material: product.material || '',
      hasDiscount: false,
      discountValue: 0,
      provider: 'brazilian',
    };
  }

  private normalizeEuropeanProduct(product: any): NormalizedProduct {
    return {
      id: `eu_${product.id}`,
      name: product.name || 'Product without name',
      description: product.description || '',
      price: parseFloat(product.price) || 0,
      category: product.details?.adjective || 'General',
      images: product.gallery || [],
      material: product.details?.material || '',
      hasDiscount: product.hasDiscount || false,
      discountValue: parseFloat(product.discountValue) || 0,
      provider: 'european',
    };
  }
}
