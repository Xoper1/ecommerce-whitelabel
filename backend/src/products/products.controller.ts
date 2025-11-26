import { Controller, Get, Param, Query, NotFoundException } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { ProductsService } from './products.service';
import { CurrentClient } from '../common/decorators/current-client.decorator';
import { Client } from '../clients/client.entity';
import { ProductFilterDto } from './dto/product-filter.dto';

@ApiTags('products')
@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Get()
  @ApiOperation({ summary: 'List all products with optional filters' })
  @ApiQuery({ name: 'search', required: false })
  @ApiQuery({ name: 'category', required: false })
  @ApiQuery({ name: 'minPrice', required: false })
  @ApiQuery({ name: 'maxPrice', required: false })
  async findAll(
    @CurrentClient() client: Client,
    @Query() filters: ProductFilterDto,
  ) {
    return this.productsService.findAll(client, filters);
  }

  @Get('categories')
  @ApiOperation({ summary: 'Get all available categories' })
  async getCategories(@CurrentClient() client: Client) {
    return this.productsService.getCategories(client);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get product by ID' })
  async findOne(
    @CurrentClient() client: Client,
    @Param('id') id: string,
  ) {
    const product = await this.productsService.findOne(client, id);

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    return product;
  }
}
