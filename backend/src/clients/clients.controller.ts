import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ClientsService } from './clients.service';
import { CurrentClient } from '../common/decorators/current-client.decorator';
import { Client } from './client.entity';

@ApiTags('clients')
@Controller('clients')
export class ClientsController {
  constructor(private readonly clientsService: ClientsService) {}

  @Get('config')
  @ApiOperation({ summary: 'Get client whitelabel configuration' })
  async getConfig(@CurrentClient() client: Client) {
    return this.clientsService.getClientConfig(client.id);
  }
}
