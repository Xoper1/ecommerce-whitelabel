import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Client } from './client.entity';

@Entity('provider_configs')
export class ProviderConfig {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  client_id: number;

  @Column({ length: 50 })
  provider_name: string; // 'brazilian' or 'european'

  @Column({ default: true })
  is_active: boolean;

  @Column({ default: 1 })
  priority: number;

  @ManyToOne(() => Client, client => client.provider_configs)
  @JoinColumn({ name: 'client_id' })
  client: Client;
}
