# S3 Direct Upload Setup

This application uses direct-to-S3 uploads via presigned URLs to handle large file uploads efficiently.

## How It Works

1. Client requests a presigned URL from `/admin/presign`
2. Rails generates a presigned POST URL for S3
3. Client uploads file directly to S3 (bypassing Rails server)
4. Client sends file metadata back to Rails for attachment

## Required Configuration

### 1. S3 CORS Configuration

Configure CORS on your S3 bucket to allow direct browser uploads:

**AWS S3 Console → Your bucket → Permissions → CORS**

Add the following CORS policy:

```json
[
  {
    "AllowedOrigins": [
      "https://your-production-domain.com",
      "http://localhost:3000"
    ],
    "AllowedMethods": ["POST", "PUT", "HEAD"],
    "AllowedHeaders": [
      "Content-Type",
      "Content-Length",
      "x-amz-*"
    ],
    "ExposedHeaders": ["ETag"],
    "MaxAgeSeconds": 300
  }
]
```

**Important:** Update `AllowedOrigins` to include your actual application domains.

### 2. Environment Variables

Ensure these are set when using S3 storage:

- `SHRINE_S3_STORAGE` - Set to any value to enable S3 storage
- `SHRINE_S3_BUCKET` - Your S3 bucket name
- `SHRINE_AWS_REGION` - AWS region (e.g., `us-east-1`)
- `SHRINE_AWS_ACCESS_KEY_ID` - AWS access key
- `SHRINE_AWS_SECRET_ACCESS_KEY` - AWS secret key

### 3. File Size Limits

- **S3**: Supports files up to 5TB (using multipart uploads)
- **Application**: No explicit file size limits configured
- **Web Server**: Ensure your web server (Nginx/Apache) allows large uploads if needed

## Testing

1. Test presign endpoint:
   ```bash
   curl "http://localhost:3000/admin/presign?filename=test.zip&type=application/zip&size=1000000"
   ```
   Should return JSON with `url`, `method`, and `fields`.

2. Check browser Network tab when uploading:
   - Should see `GET /admin/presign?...`
   - Then `POST https://your-bucket.s3.amazonaws.com/...` (direct to S3)
   - NOT `POST /admin/direct_upload` (old server-mediated flow)

## Troubleshooting

- **CORS errors**: Verify S3 bucket CORS configuration matches your domain
- **Presign endpoint 404**: Check routes are mounted correctly
- **Upload fails**: Check browser console for detailed error messages
- **Large files timeout**: S3 direct uploads should not timeout, but check network connectivity
