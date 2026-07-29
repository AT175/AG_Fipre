import {
  IsString,
  MinLength,
  IsOptional,
  IsEmail,
  IsHexColor,
  IsIn,
} from 'class-validator';

export class CreateTenantDto {
  @IsString()
  @MinLength(2)
  name: string;

  @IsString()
  @MinLength(2)
  slug: string;

  @IsString()
  @IsOptional()
  address?: string;

  @IsString()
  @IsOptional()
  phone?: string;

  @IsEmail()
  @IsOptional()
  email?: string;

  @IsHexColor()
  @IsOptional()
  primaryColor?: string;

  @IsString()
  @IsOptional()
  logoUrl?: string;

  @IsString()
  @IsOptional()
  appName?: string;

  @IsString()
  @IsOptional()
  @IsIn(['basic', 'standard', 'premium'])
  subscriptionTier?: string;
}
