import { Injectable, NestMiddleware, NotFoundException } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Client } from '../../clients/client.entity';

@Injectable()
export class ClientMiddleware implements NestMiddleware {
  constructor(
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) {}

  async use(req: Request, res: Response, next: NextFunction) {
    // Extract domain from Host header or X-Client-Domain header
    const host = req.headers['x-client-domain'] as string || req.headers.host;

    if (!host) {
      throw new NotFoundException('Client domain not found');
    }

    // Remove port from host if present
    const domain = host.split(':')[0];

    // Find client by domain
    const client = await this.clientRepository.findOne({
      where: { domain },
      relations: ['provider_configs'],
    });

    if (!client) {
      throw new NotFoundException(`Client not found for domain: ${domain}`);
    }

    // Attach client to request object
    req['client'] = client;

    next();
  }
}
