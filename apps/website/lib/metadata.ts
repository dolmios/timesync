import type { Metadata } from "next";

const baseUrl = "https://timesync.dolmios.com";

export function createMetadata({
  description,
  image,
  keywords,
  path = "",
  title,
}: {
  title: string;
  description: string;
  path?: string;
  keywords?: string[];
  image?: string;
}): Metadata {
  const url = `${baseUrl}${path}`;
  const fullTitle = path ? `${title} | Timesync` : title;
  const ogImage = image || `${baseUrl}/timesync.jpg`;

  return {
    alternates: {
      canonical: url,
    },
    description,
    keywords: keywords?.join(", "),
    openGraph: {
      description,
      images: [
        {
          alt: fullTitle,
          height: 630,
          url: ogImage,
          width: 1200,
        },
      ],
      siteName: "Timesync",
      title: fullTitle,
      type: "website",
      url,
    },
    title: fullTitle,
    twitter: {
      card: "summary_large_image",
      description,
      images: [ogImage],
      title: fullTitle,
    },
  };
}
