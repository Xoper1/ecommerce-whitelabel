import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Client } from './client.entity';

@Injectable()
export class ClientsService {
  constructor(
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) {}

  async findByDomain(domain: string): Promise<Client | null> {
    return this.clientRepository.findOne({
      where: { domain },
      relations: ['provider_configs'],
    });
  }

  async getClientConfig(clientId: number) {
    const client = await this.clientRepository.findOne({
      where: { id: clientId },
      select: ['id', 'name', 'logo_url', 'primary_color'],
    });
    return client;
  }
}
