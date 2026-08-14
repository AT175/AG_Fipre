import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AttendanceService } from './attendance.service';
import { AttendanceController } from './attendance.controller';
import { AttendanceRecord } from './attendance.entity';

@Module({
  imports: [TypeOrmModule.forFeature([AttendanceRecord])],
  providers: [AttendanceService],
  controllers: [AttendanceController],
})
export class AttendanceModule {}
