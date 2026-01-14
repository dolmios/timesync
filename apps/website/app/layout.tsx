import type { Metadata, Viewport } from "next";
import type { ReactNode } from "react";

import localFont from "next/font/local";
import { cookies } from "next/headers";

import { Breadcrumbs } from "./components/Breadcrumbs";
import { Footer } from "./components/Footer";
import { Header } from "./components/Header";
import { Providers } from "./components/Providers";
import { StructuredData } from "./components/StructuredData";
import { Styles } from "./components/Styles";
import { Wrapper } from "./components/Wrapper";

const standardFont = localFont({
  display: "swap",
  fallback: ["system-ui", "-apple-system", "sans-serif"],
  src: [
    {
      path: "../public/fonts/standard-book.woff2",
      style: "normal",
      weight: "400",
    },
    {
      path: "../public/fonts/standard-bold.woff2",
      style: "normal",
      weight: "500",
    },
  ],
  variable: "--font-standard",
});

const baseUrl = "https://timesync.dolmios.com";
const ogImage = `${baseUrl}/preview.png`;

export const metadata: Metadata = {
  alternates: {
    canonical: baseUrl,
  },
  description:
    "A macOS menu bar app for managing multiple timezones and converting times. Made for personal use to help schedule meetings across timezones.",
  keywords: [
    "macos",
    "menu bar",
    "timezone",
    "time converter",
    "timezone converter",
    "mac app",
  ],
  openGraph: {
    description:
      "A macOS menu bar app for managing multiple timezones and converting times. Made for personal use.",
    images: [
      {
        alt: "Timesync - macOS Timezone App",
        height: 630,
        url: ogImage,
        width: 1200,
      },
    ],
    siteName: "Timesync",
    title: "Timesync - macOS Timezone App",
    type: "website",
    url: baseUrl,
  },
  title: {
    default: "Timesync - macOS Timezone App",
    template: "%s | Timesync",
  },
  twitter: {
    card: "summary_large_image",
    description:
      "A macOS menu bar app for managing multiple timezones and converting times. Made for personal use.",
    images: [ogImage],
    title: "Timesync - macOS Timezone App",
  },
};

export const viewport: Viewport = {
  initialScale: 1,
  maximumScale: 5,
  width: "device-width",
};

export default async function RootLayout({
  children,
}: {
  children: ReactNode;
}): Promise<ReactNode> {
  const cookieStore = await cookies();
  const themeCookie = cookieStore.get("timesync-theme");
  const initialTheme = themeCookie?.value || "light";

  return (
    <html
      className={standardFont.variable}
      data-theme={initialTheme}
      lang="en"
      suppressHydrationWarning>
      <body suppressHydrationWarning>
        <StructuredData />
        <Styles initialTheme={initialTheme} />
        <Providers initialTheme={initialTheme}>
          <Header />
          <Wrapper>
            <Breadcrumbs />
            {children}
          </Wrapper>
          <Footer />
        </Providers>
      </body>
    </html>
  );
}
