export const formatDate = (stringDate) => {
  try {
    if (!stringDate) {
      return "-";
    }
    return new Date(stringDate).toLocaleDateString("tr-TR");
  } catch (error) {
    return "-";
  }
};

export const formatDatetime = (stringDate) => {
  try {
    if (!stringDate) {
      return "-";
    }
    return new Date(stringDate).toLocaleString("tr-TR");
  } catch (error) {
    return "-";
  }
};
