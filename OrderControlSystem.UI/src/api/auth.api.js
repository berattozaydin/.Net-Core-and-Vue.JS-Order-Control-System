import api from "./index.js";

export const useAuthApi = () => {
    async function loginUser(loginUser){
        let response;
        try{
            response = await api.post("login/LoginUser",loginUser);
            console.log(response);
            return response.data;
        }catch(error){
            console.log(error);
        }
    }
    return{
        loginUser
    };
}
export default useAuthApi;