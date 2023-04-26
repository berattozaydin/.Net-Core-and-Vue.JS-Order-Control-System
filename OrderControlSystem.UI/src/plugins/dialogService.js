import ConfirmatiOnEventBus from "primevue/confirmationeventbus"; 

export const mbox = (msg) => {
   ConfirmatiOnEventBus.emit('confirm',{
    message: msg,
    group: "mbox",
    header: "Sistem Mesajı",
    acceptLabel: "Kapat",
    icon: "pi pi-info-circle",
    rejectClass: "hidden",
  });
};

export const cbox = (msg, acceptFunction = null, rejectFunction = null) => {
   ConfirmatiOnEventBus.emit('confirm',{
    message: msg,
    group: "cbox",
    header: "Emin misiniz?",
    acceptLabel: "Onayla",
    rejectLabel: "İptal",
    icon: "pi pi-info-circle",
    rejectClass: "p-button-outlined p-button-danger",
    accept: acceptFunction,
    reject: rejectFunction,
  });
};