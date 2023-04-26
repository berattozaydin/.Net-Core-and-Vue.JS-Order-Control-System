import { createRouter, createWebHashHistory } from "vue-router";

const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/login",
      name: "Giriş Yap",
      component: () => import("@/pages/LoginPage.vue"),
    },
    {
      path: "/orders",
      name: "Siparişler",
      component: () => import("@/pages/OrderPage.vue"),
    }, 
    {
      path: "/customers",
      name: "Müşteriler",
      component: () => import("@/pages/CustomerPage.vue"),
    },
    {
      path: "/Accounts",
      name: "Kullanıcılar",
      component: () => import("@/pages/AccountPage.vue"),
    },
    {
      path: "/receipts",
      name: "Reçeteler",
      component: () => import("@/pages/ReceiptsPage.vue"),
    },
    {
      path: "/materialqualities",
      name: "Kaliteler",
      component: () => import("@/pages/MaterialQualityPage.vue"),
    },
    {
      path:"/logs",
      name:"Log Kayıtları",
      component:()=>import("@/pages/LogPage.vue"),
    }

  ],
});

router.beforeEach((to, from, next) => {
  document.title = "Order Control System | " + to.name ;
  next();
});

export default router;
