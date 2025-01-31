var Captcha = (function () {
    function Captcha() { }
    let text = "";
    //Generate Text
    const textGenerator = () => {
        let generatedText = "";
        for (let i = 0; i < 2; i++) {
            generatedText += String.fromCharCode(randomNumber(65, 90));
            generatedText += String.fromCharCode(randomNumber(97, 122));
            generatedText += String.fromCharCode(randomNumber(48, 57));
        }
        return generatedText;
    };

    //Generate random numbers between a given range
    const randomNumber = (min, max) =>
        Math.floor(Math.random() * (max - min + 1) + min);

    //Canvas part
    function drawStringOnCanvas(string) {
        //The getContext() function returns the drawing context that has all the drawing properties and functions needed to draw on canvas
        let ctx = canvas.getContext("2d");
        //clear canvas
        ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
        //array of text color
        //const textColors = ["rgb(0,0,0)", "rgb(130,130,130)"];
        const textColors = ["rgb(243,185,12)", "rgb(250,250,250)", "rgb(255,114,128)"];
        //space between letters
        const letterSpace = 80 / string.length;
        //loop through string
        for (let i = 0; i < string.length; i++) {
            //Define initial space on X axis
            const xInitialSpace = 20;
            //Set font for canvas element
            ctx.font = "20px Roboto Mono";
            //set text color
            ctx.fillStyle = textColors[randomNumber(0, 2)];
            ctx.fillText(
                string[i],
                xInitialSpace + i * letterSpace,
                randomNumber(25, 40),
                50
            );
        }
    }

    Captcha.Trigger = function () {
        userInput.value = "";
        text = textGenerator().toUpperCase().substring(0, 4);
        text = [...text].sort(() => Math.random() - 0.5).join("");
        drawStringOnCanvas(text);
        captchaValue.value = text;
    }
    return Captcha;
})();