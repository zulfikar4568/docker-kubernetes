## Buat Pod
```bash
kubectl create -f nginx-dengan-annotation.yaml
```

## Cek annotation
```bash
kubectl describe pod nginx
```

## Menambahkan Annotation di Pod yang sudah berjalan
```bash
kubectl annotate pod nginx desc2="backend tools"
# atau di bawah ini mengubah yang sudah ada
kubectl annotate pod nginx desc2=" backend tools" --overwrite
```