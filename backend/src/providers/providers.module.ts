import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { ProvidersService } from './providers.service';

@Module({
  imports: [HttpModule],
  providers: [ProvidersService],
  exports: [ProvidersService],
})
export class ProvidersModule {}
