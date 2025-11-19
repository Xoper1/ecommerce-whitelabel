import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Client } from '../clients/client.entity';
import { Exclude } from 'class-transformer';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  client_id: number;

  @Column({ unique: true, length: 255 })
  email: string;

  @Column()
  @Exclude()
  password: string;

  @Column({ length: 100 })
  name: string;

  @CreateDateColumn()
  created_at: Date;

  @ManyToOne(() => Client, client => client.users)
  @JoinColumn({ name: 'client_id' })
  client: Client;
}
