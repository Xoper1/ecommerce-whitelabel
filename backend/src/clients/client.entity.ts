import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, OneToMany } from 'typeorm';
import { User } from '../users/user.entity';
import { ProviderConfig } from './provider-config.entity';

@Entity('clients')
export class Client {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 100 })
  name: string;

  @Column({ unique: true, length: 255 })
  domain: string;

  @Column({ nullable: true, length: 500 })
  logo_url: string;

  @Column({ nullable: true, length: 7 })
  primary_color: string;

  @CreateDateColumn()
  created_at: Date;

  @OneToMany(() => User, user => user.client)
  users: User[];

  @OneToMany(() => ProviderConfig, config => config.client)
  provider_configs: ProviderConfig[];
}
