/** @type {import('next').NextConfig} */

const nextConfig = {
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: "http://backend-service.book-review.svc.cluster.local:5000/api/:path*",
      },
    ];
  },
};

export default nextConfig;