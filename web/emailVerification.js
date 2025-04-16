
/* global emailjs, tenplateParameter, user */
const inputs = document.querySelectorAll(".otp-group input"),
        verifyButton = document.querySelector(".verifyButton");
let OTP = "";
document.addEventListener("DOMContentLoaded", function () {
    let loginSuccess = document.getElementById("loginStatus").value === "true";
    let userEmail = document.getElementById("userEmail").value;

    if (loginSuccess) {
        document.getElementById("loginToVerify").style.display = "none";
        document.getElementById("verification").style.display = "block";

        if (userEmail) {
            document.getElementById("verifyEmail").innerText = userEmail; 
        }
        emailjs.init("xab6Hm4geQO67nCkl");
        const serviceID = "service_bs6c2zb", tenplateID = "template_3vh5eqi";

        const generateOTP = () => {
            return Math.floor(1000 + Math.random() * 9000);
        };
        OTP = generateOTP();
        let templateParameter = {
            from_name: "Inventory Management dev Community",
            OTP: OTP,
            message: "Please find the OTP password",
            reply_to: userEmail
        };

        emailjs.send(serviceID, tenplateID, templateParameter).then(
                (res) => {
        }, alert('Verification Process Begun!'),
                (err) => {
            alert('Verification failed, try again...');
        }
        );
        ;
    }
    inputs.forEach((input) => {
        input.addEventListener("keyup", function (e) {
            if (this.value.length >= 1) {
                e.target.value = e.target.value.substr(0, 1);
            }
            if (inputs[0].value !== "" && inputs[1].value !== "" &&
                    inputs[2].value !== "" && inputs[3].value !== "") {
                document.getElementById('verifyButton').disabled = false;
            } else {
                document.getElementById('verifyButton').disabled = true;
            }
        });
    });
    // OTP Verification Logic
    document.querySelector(".verifyButton").addEventListener("click", function (event) {
        event.preventDefault(); 
        let otpInputs = document.querySelectorAll(".otp-group input");

        let otpValues = "";
        otpInputs.forEach((input) => {
            otpValues += input.value;
        });


        if (otpValues == OTP) { 
            alert("OTP Verified Successfully!");
            window.location.href = "home.jsp"; 
            document.getElementById("verification").style.display = "block";
        } else {
            alert("Invalid OTP! Please enter a correct 4-digit code.");
        }
    });
});
