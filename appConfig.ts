// ============================================================
//  APP CONFIG — Lleva Cuentas
// ============================================================

import Promo from "../assets/images/splahs.png";
import Icon from "../assets/images/icon.png";

// ─────────────────────────────────────────────
//  TIPOS
// ─────────────────────────────────────────────
export type Language = "es" | "en";

export interface TranslationSchema {
  hero: {
    badge: string;
    tagline: string;
    description: string;
    downloadBtn: string;
    learnMoreBtn: string;
  };
  features: {
    title: string;
    titleAccent: string;
    description: string;
  };
  benefits: {
    title: string;
    description: string;
    icon: string;
  }[];
  download: {
    title: string;
    titleAccent: string;
    description: string;
    googlePlay: string;
    googlePlaySub: string;
    appStore: string;
    appStoreSub: string;
    pwa: string;
    pwaSub: string;
    downloadBtn: string;
    comingSoonBtn: string;
    recommended: string;
  };
  pwa: {
    title: string;
    titleAccent: string;
    description: string;
    prompt: string;
    promptDescription: string;
    benefits: {
      title: string;
      description: string;
    }[];
  };
  faq: {
    title: string;
    titleAccent: string;
    description: string;
  };
  faqs: {
    question: string;
    answer: string;
  }[];
  legal: {
    terms: string;
    privacy: string;
  };
  pricing: {
    title: string;
    titleAccent: string;
    description: string;
    plans: {
      name: string;
      price: string;
      period: string;
      description: string;
      features: string[];
      buttonText: string;
      isPopular?: boolean;
    }[];
  };
}

// ─────────────────────────────────────────────
//  CONFIGURACIÓN GLOBAL
// ─────────────────────────────────────────────
export const appConfig = {

  // URLs de descarga y redes sociales
  ANDROID_URL: "https://play.google.com/store/apps/details?id=com.neryad.lleva_cuentas",
  IOS_URL: "https://apps.apple.com/app/id000000000", // No publicada en App Store
  PWA_URL: "https://llevacuentas.netlify.app/",
  GITHUB_URL: "https://github.com/neryad/lleva_cuentas_flutter",
  SOCIAL: {
    TWITTER_URL: "https://x.com/neryad",
    SUPPORT_EMAIL: "contact@neryad.dev",
    TWITTER_HANDLE: "@neryad",
  },

  // Assets
  LOGO_URL: Icon,
  PROMO_URL: Promo,

  // Identidad visual — verde/teal para finanzas
  // HSL sin paréntesis: "H S% L%"
  PRIMARY_COLOR: "158 64% 38%",

  // Datos básicos de la app
  APP_NAME: "Lleva Cuentas",
  APP_TAGLINE: "Tus finanzas, bajo control.",
  APP_DESCRIPTION: "Registra ingresos y gastos, crea categorías y genera reportes en PDF, todo de forma local y segura en tu dispositivo.",

  // ─────────────────────────────────────────────
  //  FEATURE FLAGS
  // ─────────────────────────────────────────────
  SHOW_ANDROID: true,   // Disponible en Google Play
  SHOW_IOS: false,      // No publicada en App Store aún
  SHOW_PWA: true,       // Disponible como PWA en Netlify
  SHOW_PRICING: false,  // App gratuita, sin planes de pago

  // ─────────────────────────────────────────────
  //  TRADUCCIONES
  // ─────────────────────────────────────────────
  i18n: {
    defaultLanguage: "es" as Language,
    languages: ["es", "en"] as Language[],
    translations: {

      // ══════════════════════════════════════════
      //  ESPAÑOL
      // ══════════════════════════════════════════
      es: {
        hero: {
          badge: "Disponible gratis",
          tagline: "Tus finanzas, bajo control.",
          description: "Lleva Cuentas es la app sencilla e intuitiva para registrar ingresos y gastos, organizar categorías y monitorear tu salud financiera, todo guardado localmente en tu dispositivo.",
          downloadBtn: "Descargar Gratis",
          learnMoreBtn: "Conocer más",
        },

        features: {
          title: "¿Por qué elegir",
          titleAccent: "Lleva Cuentas",
          description: "Una herramienta diseñada para que cualquier persona pueda tomar el control de sus finanzas personales de forma simple, privada y sin complicaciones.",
        },

        benefits: [
          {
            icon: "WifiOff",
            title: "100 % Local y Privado",
            description: "Tus datos nunca salen de tu dispositivo. Sin servidores externos, sin cuentas, sin rastreo.",
          },
          {
            icon: "BarChart",
            title: "Reportes y Analíticas",
            description: "Visualiza tus hábitos financieros con gráficas y exporta reportes en PDF con un solo toque.",
          },
          {
            icon: "Layers",
            title: "Categorías Personalizables",
            description: "Organiza tus transacciones en las categorías que tú defines para un seguimiento preciso.",
          },
          {
            icon: "Shield",
            title: "Protección por Contraseña",
            description: "Activa el bloqueo por contraseña opcional para mantener tus finanzas a salvo de miradas ajenas.",
          },
        ],

        download: {
          title: "Descarga",
          titleAccent: "Lleva Cuentas",
          description: "Disponible en Android y como PWA para cualquier dispositivo. Elige la opción que mejor se adapte a ti.",
          googlePlay: "Google Play",
          googlePlaySub: "Para dispositivos Android",
          appStore: "App Store",
          appStoreSub: "Para iPhone y iPad",
          pwa: "Versión Web (PWA)",
          pwaSub: "Sin descargar desde tiendas",
          downloadBtn: "Descargar",
          comingSoonBtn: "Pronto",
          recommended: "Recomendado",
        },

        pwa: {
          title: "¿Qué es una",
          titleAccent: "PWA",
          description: "La versión PWA de Lleva Cuentas funciona directamente desde tu navegador y puede instalarse como una app nativa sin pasar por ninguna tienda oficial.",
          prompt: "¿Cuándo usar la PWA?",
          promptDescription: "Es ideal si utilizas un iPhone o iPad (sin versión en App Store), si quieres probar la app antes de instalarla, o si simplemente prefieres no ocupar espacio de almacenamiento.",
          benefits: [
            {
              title: "Sin tienda de apps",
              description: "Instala directamente desde tu navegador sin pasar por Google Play o App Store.",
            },
            {
              title: "Siempre actualizada",
              description: "Las actualizaciones se aplican automáticamente sin necesidad de descargar nada.",
            },
            {
              title: "Funciona offline",
              description: "Una vez instalada, funciona incluso sin conexión a internet gracias al almacenamiento local.",
            },
          ],
        },

        faq: {
          title: "Preguntas",
          titleAccent: "Frecuentes",
          description: "Resolvemos las dudas más comunes sobre Lleva Cuentas.",
        },

        faqs: [
          {
            question: "¿Qué es Lleva Cuentas?",
            answer: "Lleva Cuentas es una aplicación de finanzas personales que te permite registrar ingresos y gastos, crear categorías y generar reportes en PDF, todo guardado de forma local en tu dispositivo.",
          },
          {
            question: "¿Cómo funciona?",
            answer: "Agrega una transacción indicando si es un ingreso o gasto, asígnale una categoría y un monto. La app registra todo en tu dispositivo y te muestra reportes y gráficas para que entiendas tus hábitos financieros.",
          },
          {
            question: "¿Está disponible para iPhone?",
            answer: "Por el momento Lleva Cuentas no está publicada en la App Store, pero puedes usar la versión PWA (web progresiva) desde Safari en tu iPhone o iPad con experiencia casi nativa.",
          },
          {
            question: "¿La aplicación recopila mis datos?",
            answer: "No. Todos tus ingresos, gastos y categorías se almacenan exclusivamente en la base de datos local de tu dispositivo. Lleva Cuentas no envía ningún dato a servidores externos.",
          },
          {
            question: "¿Puedo exportar mis datos?",
            answer: "Sí. Puedes exportar tus transacciones y reportes en formato PDF directamente desde la app, ideal para compartir o archivar tu historial financiero.",
          },
          {
            question: "¿Es gratis?",
            answer: "Sí, Lleva Cuentas es completamente gratuita. Puedes descargarla desde Google Play o usarla como PWA sin ningún costo.",
          },
        ],

        legal: {
          terms: "Términos de Uso",
          privacy: "Política de Privacidad",
        },

        pricing: {
          title: "Planes",
          titleAccent: "Simples",
          description: "Sin sorpresas ni costos ocultos.",
          plans: [
            {
              name: "Gratis",
              price: "$0",
              period: "/siempre",
              description: "Acceso completo a todas las funciones sin costo.",
              features: [
                "Registro ilimitado de transacciones",
                "Categorías personalizables",
                "Exportación en PDF",
                "Modo offline",
                "Protección por contraseña",
              ],
              buttonText: "Empezar Gratis",
            },
          ],
        },
      },

      // ══════════════════════════════════════════
      //  ENGLISH
      // ══════════════════════════════════════════
      en: {
        hero: {
          badge: "Free to download",
          tagline: "Your finances, under control.",
          description: "Lleva Cuentas is the simple, intuitive app to track your income and expenses, organize categories and monitor your financial health — all stored locally on your device.",
          downloadBtn: "Download Free",
          learnMoreBtn: "Learn More",
        },

        features: {
          title: "Why choose",
          titleAccent: "Lleva Cuentas",
          description: "A tool designed so anyone can take control of their personal finances in a simple, private, and hassle-free way.",
        },

        benefits: [
          {
            icon: "WifiOff",
            title: "100% Local & Private",
            description: "Your data never leaves your device. No external servers, no accounts, no tracking.",
          },
          {
            icon: "BarChart",
            title: "Reports & Analytics",
            description: "Visualize your financial habits with charts and export PDF reports with a single tap.",
          },
          {
            icon: "Layers",
            title: "Custom Categories",
            description: "Organize your transactions into categories you define for precise tracking.",
          },
          {
            icon: "Shield",
            title: "Password Protection",
            description: "Enable optional password lock to keep your finances safe from prying eyes.",
          },
        ],

        download: {
          title: "Download",
          titleAccent: "Lleva Cuentas",
          description: "Available on Android and as a PWA for any device. Choose the option that best suits you.",
          googlePlay: "Google Play",
          googlePlaySub: "For Android devices",
          appStore: "App Store",
          appStoreSub: "For iPhone and iPad",
          pwa: "Web Version (PWA)",
          pwaSub: "No store download required",
          downloadBtn: "Download",
          comingSoonBtn: "Soon",
          recommended: "Recommended",
        },

        pwa: {
          title: "What is a",
          titleAccent: "PWA",
          description: "The PWA version of Lleva Cuentas runs directly from your browser and can be installed like a native app without going through any official store.",
          prompt: "When to use the PWA?",
          promptDescription: "It's ideal if you use an iPhone or iPad (no App Store version yet), want to try the app before installing, or simply prefer not to use storage space.",
          benefits: [
            {
              title: "No App Store needed",
              description: "Install directly from your browser without going through Google Play or App Store.",
            },
            {
              title: "Always Updated",
              description: "Updates are applied automatically without having to download anything.",
            },
            {
              title: "Works Offline",
              description: "Once installed, it works even without an internet connection thanks to local storage.",
            },
          ],
        },

        faq: {
          title: "Frequently Asked",
          titleAccent: "Questions",
          description: "We answer the most common questions about Lleva Cuentas.",
        },

        faqs: [
          {
            question: "What is Lleva Cuentas?",
            answer: "Lleva Cuentas is a personal finance app that lets you record income and expenses, create custom categories, and generate PDF reports — all stored locally on your device.",
          },
          {
            question: "How does it work?",
            answer: "Add a transaction by specifying whether it's income or an expense, assign a category and an amount. The app stores everything on your device and shows you reports and charts to understand your financial habits.",
          },
          {
            question: "Is it available for iPhone?",
            answer: "Lleva Cuentas is not currently published on the App Store, but you can use the PWA (progressive web app) version from Safari on your iPhone or iPad for a near-native experience.",
          },
          {
            question: "Does the app collect my data?",
            answer: "No. All your income, expenses, and categories are stored exclusively in your device's local database. Lleva Cuentas does not send any data to external servers.",
          },
          {
            question: "Can I export my data?",
            answer: "Yes. You can export your transactions and reports in PDF format directly from the app — perfect for sharing or archiving your financial history.",
          },
          {
            question: "Is it free?",
            answer: "Yes, Lleva Cuentas is completely free. Download it from Google Play or use it as a PWA at no cost.",
          },
        ],

        legal: {
          terms: "Terms of Use",
          privacy: "Privacy Policy",
        },

        pricing: {
          title: "Simple",
          titleAccent: "Pricing",
          description: "No surprises or hidden costs.",
          plans: [
            {
              name: "Free",
              price: "$0",
              period: "/forever",
              description: "Full access to all features at no cost.",
              features: [
                "Unlimited transaction records",
                "Custom categories",
                "PDF export",
                "Offline mode",
                "Password protection",
              ],
              buttonText: "Start Free",
            },
          ],
        },
      },
    } as Record<Language, TranslationSchema>,
  },
};
