import api from "./index.js";

export const useReportApi = () => {
  async function getCustomerReport(customerOrderItemId) {
    let response;
    try {
      response = await api.get(
        "Report/GetCustomerReport?customerOrderItemId=" +
          customerOrderItemId
      ); 
      return response.data;
    } catch (error) {
      console.log(error);
    }
  }

  return {
    getCustomerReport,
  };
};
export default useReportApi;
