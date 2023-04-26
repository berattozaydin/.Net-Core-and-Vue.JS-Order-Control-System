export const objectToQueryForApi = (params) => {
  let q = "";
  if (params) {
    for (const key in params) {
      let val;
      if (typeof params[key] == "object") {
        val = JSON.stringify(params[key]);
      } else {
        val = params[key];
      }

      q += `${key}=${val}&`;
    }
  }
  q = q.substring(0, q.length - 1);
  return q;
};
export const formatDatetime = (dati) => {
  return dati ? new Date(dati)?.toLocaleString("tr-TR") : "-";
};

export const formatDate = (dati) => {
  return dati ? new Date(dati)?.toLocaleDateString("tr-TR") : "-";
};
export const dateToIso = (date) => {
  let dateLocal = null;
  if (!date) return null;
  if (!(date instanceof Date)) {
      dateLocal = new Date(date);
  } else {
      dateLocal = new Date(date.getTime());
  }
  dateLocal.setHours(dateLocal.getHours() + 3);
  let strDate = dateLocal.toISOString();
  return strDate.substring(0, 19);
};

export function downloadFile(base64, fileName) {
  let binaryString = window.atob(base64);
  let bytes = new Uint8Array(binaryString.length);

  for (let i = 0; i < binaryString.length; i++) {
      bytes[i] = binaryString.charCodeAt(i);
  }

  let blob = new Blob([bytes.buffer], { type: "application/octet-stream" });
  let link = document.createElement("a");
  document.body.appendChild(link);
  link.href = window.URL.createObjectURL(blob);
  link.download = fileName;
  link.click();
  setTimeout(() => document.body.removeChild(link), 2000);
 
}
export const flatFiltersForApi = (obj) => {
  if (obj.filters) {
      for (let prop in obj.filters) {
          let val = obj.filters[prop].value;
          if (
              val ||
              (typeof val === "number" && val === 0) ||
              (typeof val === "string" && val === "0")
          ) {
              if (typeof val === "object" && !("START" in val) && !("END" in val)) {
                  continue;
              } else if (
                  typeof val === "object" &&
                  ("START" in val || "END" in val)
              ) {
                  obj[prop] = {
                      START: null,
                      END: null,
                  };
                  if (val.START) {
                      obj[prop].START = dateToIso(val.START);
                  }
                  if (val.END) {
                      obj[prop].END = dateToIso(val.END);
                  }
              } else if (val instanceof Date) {
                  obj[prop] = dateToIso(val);
              } else {
                  obj[prop] = val;
              }
          } else {
              delete obj[prop];
          }
      }
      delete obj.filters;
  }

  return obj;
};