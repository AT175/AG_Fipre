import {
  IsString,
  MinLength,
  IsOptional,
  IsEmail,
  IsDateString,
  IsBoolean,
} from 'class-validator';

export class CreateMemberDto {
  @IsString()
  @MinLength(1)
  firstName: string;

  @IsString()
  @MinLength(1)
  lastName: string;

  @IsEmail()
  @IsOptional()
  email?: string;

  @IsString()
  @IsOptional()
  phone?: string;

  @IsString()
  @IsOptional()
  gender?: string;

  @IsDateString()
  @IsOptional()
  dateOfBirth?: string;

  @IsString()
  @IsOptional()
  maritalStatus?: string;

  @IsBoolean()
  @IsOptional()
  isEmployed?: boolean;

  @IsString()
  @IsOptional()
  address?: string;

  @IsString()
  @IsOptional()
  city?: string;
}
