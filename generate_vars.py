import random

#bucket = f"site-auto-{random.randint(1000,9999)}"

with open("terraform.tfvars", "w") as f:
    #f.write(f'bucket_name = "{bucket}"\n')
    f.write('environment = "dev"\n')
    f.write('aws_region = "us-east-1"\n')

    

print("terraform.tfvars généré avec succès")
