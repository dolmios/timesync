import createMDX from "@next/mdx";

/** @type {import('next').NextConfig} */
const nextConfig = {
  pageExtensions: ["ts", "tsx", "js", "jsx", "md", "mdx"],
  reactStrictMode: true,
  typescript: {
    ignoreBuildErrors: false,
  },
  images: {
    qualities: [100, 75],
  },
};

const withMDX = createMDX({
  extension: /\.mdx?$/,
  options: {
    rehypePlugins: [
      'rehype-slug', // Add IDs to headings
    ],
    remarkPlugins: [
      'remark-gfm', // GitHub Flavored Markdown
    ],
  },
});

export default withMDX(nextConfig);
