# sprint1-terraform

Sprint1(BMI計算アプリ)の構成をTerraformで構築したもの。

## 構成
<img width="705" height="805" alt="image" src="https://github.com/user-attachments/assets/30530662-1d9f-412f-98dd-8eae45b82c75" />


- VPC(`10.0.0.0/16`)、インターネットゲートウェイ
- パブリックサブネット(`10.0.1.0/24`)/ プライベートサブネット(`10.0.2.0/24`)、いずれも`ap-northeast-1a`
- NAT Gateway(パブリックサブネットに配置、プライベートサブネットからのアウトバウンド用)
- Webサーバ(パブリックサブネット、Elastic IP付き)
  - nginxで[sprint1-frontend](https://github.com/CloudTechOrg/sprint1-frontend)を配信
  - `/api/`へのリクエストをAPIサーバの8080番へリバースプロキシ
- APIサーバ(プライベートサブネット)
  - [sprint1-api](https://github.com/CloudTechOrg/sprint1-api)をビルドしてsystemdで常駐
- セキュリティグループ
  - Webサーバ: 80番をインターネットから許可
  - APIサーバ: 8080番をWebサーバのSGからのみ許可(インターネットから直接アクセス不可)

## 構築手順

```bash
terraform init
terraform plan
terraform apply
```

`terraform output web_public_ip`で表示されるIPアドレスにブラウザでアクセスして動作を確認する。

## 削除

```bash
terraform destroy
```
