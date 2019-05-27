if (window.addEventListener) {
    window.addEventListener('load', () => {

        let errors = {};
        const alerts = document.querySelector("#alerts");

        const register = document.querySelector("#register");
        register.addEventListener('submit', (e) => {
            e.preventDefault();
            errors = { count: 0, items: [] };
            document.querySelector("#alerts").innerHTML = "";

            const email = register.querySelector("#r_email").value;
            const password = register.querySelector("#r_password").value;
            const password_confirm = register.querySelector("#r_password_confirm").value;

            // Validation of email
            if (!ValidateEmail(email)) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Invalid Email address" });
            };

            // Min Password length
            if (password.length < 8) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Password must be minimum 8 characters" });
            }

            // Regex check for password character content
            if (password.replace(/[^a-z]/g, "").length < 1) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Passwords must include lowercase letter(s)" });
            };
            if (password.replace(/[^A-Z]/g, "").length < 1) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Passwords must include uppercase letter(s)" });
            };
            if (password.replace(/[^0-9]/g, "").length < 1) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Passwords must include number(s)" });
            };
            if (password.replace(/[a-zA-Z0-9]/g, "").length < 1) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Passwords must include special character(s)" });
            };

            // password matching
            if (password !== password_confirm) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Passwords do not match" });
            }

            let errAlerts = [];
            errors.items.map(item => {
                errAlerts.push(
                    `<div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Error: </strong> ${item.message}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>`
                )
            });
            alerts.innerHTML = errAlerts.join('');
            if (errors.count === 0) register.submit();

        });

        const login = document.querySelector("#login");
        login.addEventListener('submit', (e) => {
            e.preventDefault();
            errors = { count: 0, items: [] };

            const email = login.querySelector("#l_email").value;
            const password = login.querySelector("#l_password").value;

            // Check for Valid email
            if (!ValidateEmail(email)) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Invalid Email address" });
            };

            // Min length of password required
            if (password.length < 8) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Password must be minimum 8 characters" });
            }

            // Regex check for password character content
            if (password.replace(/[^a-z]/g, "").length < 1) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Passwords must include lowercase letter(s)" });
            };
            console.log(password.replace(/[^A-Z]/gi, ""));
            if (password.replace(/[^A-Z]/g, "").length < 1) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Passwords must include uppercase letter(s)" });
            };
            if (password.replace(/[^0-9]/g, "").length < 1) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Passwords must include number(s)" });
            };
            if (password.replace(/[a-zA-Z0-9]/g, "").length < 1) {
                errors.count += 1;
                errors.items.push({ valid: false, message: "Passwords must include special character(s)" });
            };

            let errAlerts = [];
            errors.items.map(item => {
                errAlerts.push(
                    `<div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Error: </strong> ${item.message}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>`
                )
            });
            alerts.innerHTML = errAlerts.join('');

            if (errors.count === 0) login.submit();

        });

    }, false); //W3C
} else {
    alert("This browser no longer supported");
}

const ValidateEmail = (email) => {
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
        return (true)
    }
    return (false)
}