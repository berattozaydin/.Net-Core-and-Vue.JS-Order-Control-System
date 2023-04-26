import ToastEventBus from "primevue/toasteventbus";

const options = {
  life: 3000,
};

export const toastSuccess = (message) => {
  ToastEventBus.emit("add", {
    severity: "success",
    summary: "Başarılı",
    detail: message,
    life: options?.life || 3000,
    group: "main",
  });
};

export const toastInfo = (message) => {
  ToastEventBus.emit("add", {
    severity: "info",
    summary: "Uyarı",
    detail: message,
    life: options?.life || 3000,
    group: "main",
  });
};

export const toastWarn = (message) => {
  ToastEventBus.emit("add", {
    severity: "warn",
    summary: "Dikkat",
    detail: message,
    life: options?.life || 3000,
    group: "main",
  });
};

export const toastError = (message) => {
  ToastEventBus.emit("add", {
    severity: "error",
    summary: "Hata",
    detail: message,
    life: options?.life || 3000,
    group: "main",
  });
};
