local instance = {}
local position = Vector2 (screen.x - (337 * scale), 23 * scale);
local positionSpeed = Vector2(screen.x - ((206+53) * scale), screen.y - 142-37 * scale);

instance.interpolates = {};
instance.stroke = 2.7;

instance.fps = 0;
instance.nextTick = 0;
instance.voiceEnabled = false;

instance.svg = {

    ['background'] = svgCreate(60 * scale, 60 * scale, [[
        <svg width="60" height="60" viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
            <circle opacity="0.96" cx="30" cy="30" r="30" fill="#1A1A1C"/>
            <circle opacity="0.7" cx="30" cy="30" r="30" fill="url(#paint0_radial_309_9)"/>
            <defs>
            <radialGradient id="paint0_radial_309_9" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(30 30) rotate(90) scale(30)">
            <stop stop-color="#5C5C5C"/>
            <stop offset="1" stop-color="#858EAD" stop-opacity="0"/>
            </radialGradient>
            </defs>
        </svg>
    ]]);

    ['armor'] = svgCreate(41 * scale, 45 * scale, [[
        <svg width="41" height="45" viewBox="0 0 41 45" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M20.5 7.0835L7.14282 12.6896V21.0986C7.14282 28.8771 12.8419 36.1509 20.5 37.9168C28.1581 36.1509 33.8571 28.8771 33.8571 21.0986V12.6896L20.5 7.0835ZM20.5 12.6896C21.6808 12.6896 22.8133 13.1325 23.6483 13.921C24.4833 14.7095 24.9523 15.779 24.9523 16.8941C24.9523 18.0092 24.4833 19.0787 23.6483 19.8672C22.8133 20.6557 21.6808 21.0986 20.5 21.0986C19.3191 21.0986 18.1866 20.6557 17.3517 19.8672C16.5167 19.0787 16.0476 18.0092 16.0476 16.8941C16.0476 15.779 16.5167 14.7095 17.3517 13.921C18.1866 13.1325 19.3191 12.6896 20.5 12.6896ZM28.1135 29.5077C26.3144 32.1063 23.6277 34.0451 20.5 35.0017C17.3722 34.0451 14.6855 32.1063 12.8864 29.5077C12.3818 28.807 11.9514 28.1062 11.5952 27.3634C11.5952 25.0509 15.6172 23.1589 20.5 23.1589C25.3827 23.1589 29.4047 25.0089 29.4047 27.3634C29.0485 28.1062 28.6181 28.807 28.1135 29.5077Z" fill="#4589EE"/>
            <g filter="url(#filter0_f_255_4)">
            <path d="M20.5002 7.08398L7.14307 12.69V21.0991C7.14307 28.8775 12.8421 36.1514 20.5002 37.9173C28.1583 36.1514 33.8574 28.8775 33.8574 21.0991V12.69L20.5002 7.08398ZM20.5002 12.69C21.6811 12.69 22.8135 13.133 23.6485 13.9215C24.4835 14.71 24.9526 15.7795 24.9526 16.8946C24.9526 18.0097 24.4835 19.0791 23.6485 19.8677C22.8135 20.6562 21.6811 21.0991 20.5002 21.0991C19.3194 21.0991 18.1869 20.6562 17.3519 19.8677C16.5169 19.0791 16.0478 18.0097 16.0478 16.8946C16.0478 15.7795 16.5169 14.71 17.3519 13.9215C18.1869 13.133 19.3194 12.69 20.5002 12.69ZM28.1138 29.5082C26.3147 32.1068 23.6279 34.0456 20.5002 35.0022C17.3725 34.0456 14.6857 32.1068 12.8866 29.5082C12.382 28.8075 11.9516 28.1067 11.5954 27.3639C11.5954 25.0514 15.6174 23.1594 20.5002 23.1594C25.383 23.1594 29.405 25.0094 29.405 27.3639C29.0488 28.1067 28.6184 28.8075 28.1138 29.5082Z" fill="#4589EE"/>
            </g>
            <defs>
            <filter id="filter0_f_255_4" x="0.243066" y="0.183984" width="40.5144" height="44.6335" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
            <feFlood flood-opacity="0" result="BackgroundImageFix"/>
            <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
            <feGaussianBlur stdDeviation="3.45" result="effect1_foregroundBlur_255_4"/>
            </filter>
            </defs>
        </svg>
    ]]);


    ['life'] = svgCreate(44 * scale, 40 * scale, [[
       <svg width="44" height="40" viewBox="0 0 44 40" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M29.5492 6.09082C31.8459 6.09082 33.7907 6.95002 35.3839 8.66842C36.977 10.3868 37.773 12.4606 37.7718 14.8896C37.7718 15.6026 37.6922 16.3133 37.533 17.0216C37.3738 17.73 37.1192 18.415 36.7692 19.0765H27.6863L24.5433 14.3121H22.9016L19.9571 23.0972L17.1513 19.0765H7.16757C6.81875 18.415 6.56415 17.7352 6.40379 17.0371C6.24576 16.3401 6.16675 15.6391 6.16675 14.9342C6.16675 12.4743 6.9557 10.3857 8.53362 8.66842C10.1115 6.95116 12.0488 6.09196 14.3454 6.09082C15.5464 6.09082 16.7018 6.32961 17.8115 6.8072C18.92 7.28365 19.912 7.97432 20.7876 8.87922L21.9693 10.0995L23.0842 8.94606C23.975 8.01831 24.9805 7.3105 26.1008 6.82263C27.221 6.33476 28.3705 6.09082 29.5492 6.09082ZM21.9254 34.5473L9.32023 22.158C9.10017 21.9432 8.88829 21.7221 8.68462 21.4947C8.48211 21.2697 8.29658 21.0349 8.12802 20.7903H16.2101L19.4409 25.5325H21.0738L23.9832 16.7046L26.7785 20.7903H35.8018C35.6332 21.028 35.4477 21.2599 35.2452 21.4862C35.0427 21.7124 34.8343 21.9329 34.6201 22.1477L21.9254 34.5473Z" fill="#FF2B5C"/>
            <g filter="url(#filter0_f_282_3)">
            <path d="M29.5492 6.09082C31.8459 6.09082 33.7907 6.95002 35.3839 8.66842C36.977 10.3868 37.773 12.4606 37.7718 14.8896C37.7718 15.6026 37.6922 16.3133 37.533 17.0216C37.3738 17.73 37.1192 18.415 36.7692 19.0765H27.6863L24.5433 14.3121H22.9016L19.9571 23.0972L17.1513 19.0765H7.16757C6.81875 18.415 6.56415 17.7352 6.40379 17.0371C6.24576 16.3401 6.16675 15.6391 6.16675 14.9342C6.16675 12.4743 6.9557 10.3857 8.53362 8.66842C10.1115 6.95116 12.0488 6.09196 14.3454 6.09082C15.5464 6.09082 16.7018 6.32961 17.8115 6.8072C18.92 7.28365 19.912 7.97432 20.7876 8.87922L21.9693 10.0995L23.0842 8.94606C23.975 8.01831 24.9805 7.3105 26.1008 6.82263C27.221 6.33476 28.3705 6.09082 29.5492 6.09082ZM21.9254 34.5473L9.32023 22.158C9.10017 21.9432 8.88829 21.7221 8.68462 21.4947C8.48211 21.2697 8.29658 21.0349 8.12802 20.7903H16.2101L19.4409 25.5325H21.0738L23.9832 16.7046L26.7785 20.7903H35.8018C35.6332 21.028 35.4477 21.2599 35.2452 21.4862C35.0427 21.7124 34.8343 21.9329 34.6201 22.1477L21.9254 34.5473Z" fill="#FF2B5C"/>
            </g>
            <defs>
            <filter id="filter0_f_282_3" x="0.766748" y="0.69082" width="42.405" height="39.2565" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
            <feFlood flood-opacity="0" result="BackgroundImageFix"/>
            <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
            <feGaussianBlur stdDeviation="2.7" result="effect1_foregroundBlur_282_3"/>
            </filter>
            </defs>
        </svg>
    ]]);

    ['food'] = svgCreate(30 * scale, 34 * scale, [[
       <svg width="30" height="34" viewBox="0 0 30 34" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M3 6.4224C3 4.50621 4.53427 2.88402 6.47997 3.00651C14.1033 3.486 20.789 6.10391 26.0261 11.2085C27.5123 12.6557 27.2192 15.0199 25.6781 16.2273L25.2598 16.5563L24.5792 15.7846L24.5672 15.7723C19.5341 10.4963 12.2399 7.39887 4.49313 7.39887H3V6.4224ZM3 9.14706V28.3737C3 30.5296 5.41026 31.765 7.10568 30.4753L9.86222 28.3789V28.3824C9.86222 28.8465 10.0428 29.2916 10.3643 29.6198C10.6858 29.948 11.1218 30.1323 11.5765 30.1323C12.0311 30.1323 12.4672 29.948 12.7887 29.6198C13.1102 29.2916 13.2908 28.8465 13.2908 28.3824V24.879C13.2925 24.6571 13.3768 24.4442 13.5265 24.2834C13.6762 24.1225 13.8802 24.0257 14.0972 24.0126C14.3142 23.9995 14.5279 24.071 14.6952 24.2127C14.8625 24.3544 14.9708 24.5557 14.9982 24.7758V25.7557C14.9982 26.2199 15.1788 26.665 15.5003 26.9931C15.8218 27.3213 16.2578 27.5057 16.7124 27.5057C17.1671 27.5057 17.6031 27.3213 17.9246 26.9931C18.2461 26.665 18.4267 26.2199 18.4267 25.7557V21.8394C19.841 20.7807 22.0027 19.1025 23.8952 17.6255L23.3278 16.9798C18.6324 12.066 11.7942 9.14706 4.49141 9.14706H3ZM10.2822 13.9454C10.2821 14.1172 10.2488 14.2873 10.1843 14.4459C10.1198 14.6046 10.0254 14.7487 9.90629 14.8701C9.78722 14.9915 9.6459 15.0877 9.49039 15.1534C9.33487 15.219 9.16822 15.2527 8.99994 15.2526C8.83167 15.2525 8.66506 15.2185 8.50963 15.1527C8.35421 15.0869 8.21301 14.9904 8.0941 14.8689C7.97519 14.7473 7.88089 14.603 7.8166 14.4443C7.75231 14.2855 7.71927 14.1154 7.71938 13.9436C7.71938 13.5967 7.85439 13.264 8.0947 13.0187C8.33502 12.7734 8.66095 12.6356 9.0008 12.6356C9.34065 12.6356 9.66659 12.7734 9.9069 13.0187C10.1472 13.264 10.2822 13.5967 10.2822 13.9436M15.3822 17.4435C15.3822 17.7905 15.2472 18.1232 15.0069 18.3685C14.7665 18.6138 14.4406 18.7516 14.1008 18.7516C13.7609 18.7516 13.435 18.6138 13.1947 18.3685C12.9543 18.1232 12.8193 17.7905 12.8193 17.4435C12.8193 17.0966 12.9543 16.7639 13.1947 16.5186C13.435 16.2733 13.7609 16.1354 14.1008 16.1354C14.4406 16.1354 14.7665 16.2733 15.0069 16.5186C15.2472 16.7639 15.3822 17.0966 15.3822 17.4435ZM10.2959 21.8219C10.2959 22.1707 10.1602 22.5052 9.91861 22.7518C9.67701 22.9984 9.34933 23.137 9.00766 23.137C8.66599 23.137 8.33831 22.9984 8.09671 22.7518C7.85511 22.5052 7.71938 22.1707 7.71938 21.8219C7.71938 21.4731 7.85511 21.1386 8.09671 20.892C8.33831 20.6454 8.66599 20.5068 9.00766 20.5068C9.34933 20.5068 9.67701 20.6454 9.91861 20.892C10.1602 21.1386 10.2959 21.4731 10.2959 21.8219Z" fill="#F8C14F"/>
            <g filter="url(#filter0_f_309_3)">
            <path d="M3 6.4224C3 4.50621 4.53427 2.88402 6.47997 3.00651C14.1033 3.486 20.789 6.10391 26.0261 11.2085C27.5123 12.6557 27.2192 15.0199 25.6781 16.2273L25.2598 16.5563L24.5792 15.7846L24.5672 15.7723C19.5341 10.4963 12.2399 7.39887 4.49313 7.39887H3V6.4224ZM3 9.14706V28.3737C3 30.5296 5.41026 31.765 7.10568 30.4753L9.86222 28.3789V28.3824C9.86222 28.8465 10.0428 29.2916 10.3643 29.6198C10.6858 29.948 11.1218 30.1323 11.5765 30.1323C12.0311 30.1323 12.4672 29.948 12.7887 29.6198C13.1102 29.2916 13.2908 28.8465 13.2908 28.3824V24.879C13.2925 24.6571 13.3768 24.4442 13.5265 24.2834C13.6762 24.1225 13.8802 24.0257 14.0972 24.0126C14.3142 23.9995 14.5279 24.071 14.6952 24.2127C14.8625 24.3544 14.9708 24.5557 14.9982 24.7758V25.7557C14.9982 26.2199 15.1788 26.665 15.5003 26.9931C15.8218 27.3213 16.2578 27.5057 16.7124 27.5057C17.1671 27.5057 17.6031 27.3213 17.9246 26.9931C18.2461 26.665 18.4267 26.2199 18.4267 25.7557V21.8394C19.841 20.7807 22.0027 19.1025 23.8952 17.6255L23.3278 16.9798C18.6324 12.066 11.7942 9.14706 4.49141 9.14706H3ZM10.2822 13.9454C10.2821 14.1172 10.2488 14.2873 10.1843 14.4459C10.1198 14.6046 10.0254 14.7487 9.90629 14.8701C9.78722 14.9915 9.6459 15.0877 9.49039 15.1534C9.33487 15.219 9.16822 15.2527 8.99994 15.2526C8.83167 15.2525 8.66506 15.2185 8.50963 15.1527C8.35421 15.0869 8.21301 14.9904 8.0941 14.8689C7.97519 14.7473 7.88089 14.603 7.8166 14.4443C7.75231 14.2855 7.71927 14.1154 7.71938 13.9436C7.71938 13.5967 7.85439 13.264 8.0947 13.0187C8.33502 12.7734 8.66095 12.6356 9.0008 12.6356C9.34065 12.6356 9.66659 12.7734 9.9069 13.0187C10.1472 13.264 10.2822 13.5967 10.2822 13.9436M15.3822 17.4435C15.3822 17.7905 15.2472 18.1232 15.0069 18.3685C14.7665 18.6138 14.4406 18.7516 14.1008 18.7516C13.7609 18.7516 13.435 18.6138 13.1947 18.3685C12.9543 18.1232 12.8193 17.7905 12.8193 17.4435C12.8193 17.0966 12.9543 16.7639 13.1947 16.5186C13.435 16.2733 13.7609 16.1354 14.1008 16.1354C14.4406 16.1354 14.7665 16.2733 15.0069 16.5186C15.2472 16.7639 15.3822 17.0966 15.3822 17.4435ZM10.2959 21.8219C10.2959 22.1707 10.1602 22.5052 9.91861 22.7518C9.67701 22.9984 9.34933 23.137 9.00766 23.137C8.66599 23.137 8.33831 22.9984 8.09671 22.7518C7.85511 22.5052 7.71938 22.1707 7.71938 21.8219C7.71938 21.4731 7.85511 21.1386 8.09671 20.892C8.33831 20.6454 8.66599 20.5068 9.00766 20.5068C9.34933 20.5068 9.67701 20.6454 9.91861 20.892C10.1602 21.1386 10.2959 21.4731 10.2959 21.8219Z" fill="#F8C14F"/>
            </g>
            <defs>
            <filter id="filter0_f_309_3" x="0.5" y="0.5" width="29" height="33" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
            <feFlood flood-opacity="0" result="BackgroundImageFix"/>
            <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
            <feGaussianBlur stdDeviation="1.25" result="effect1_foregroundBlur_309_3"/>
            </filter>
            </defs>
        </svg>
    ]]);

    ['thirst'] = svgCreate(34 * scale, 40 * scale, [[
        <svg width="34" height="40" viewBox="0 0 34 40" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M17.4125 30.5C17.7125 30.475 17.969 30.356 18.182 30.143C18.395 29.93 18.501 29.674 18.5 29.375C18.5 29.025 18.3875 28.744 18.1625 28.532C17.9375 28.32 17.65 28.226 17.3 28.25C16.275 28.325 15.1875 28.044 14.0375 27.407C12.8875 26.77 12.1625 25.6135 11.8625 23.9375C11.8125 23.6625 11.6815 23.4375 11.4695 23.2625C11.2575 23.0875 11.0135 23 10.7375 23C10.3875 23 10.1 23.1315 9.875 23.3945C9.65 23.6575 9.575 23.9635 9.65 24.3125C10.075 26.5875 11.075 28.2125 12.65 29.1875C14.225 30.1625 15.8125 30.6 17.4125 30.5ZM17 35C13.575 35 10.719 33.825 8.432 31.475C6.145 29.125 5.001 26.2 5 22.7C5 20.2 5.994 17.4815 7.982 14.5445C9.97 11.6075 12.976 8.426 17 5C21.025 8.425 24.0315 11.6065 26.0195 14.5445C28.0075 17.4825 29.001 20.201 29 22.7C29 26.2 27.8565 29.125 25.5695 31.475C23.2825 33.825 20.426 35 17 35Z" fill="#6FFEFB"/>
            <g filter="url(#filter0_f_309_7)">
            <path d="M17.4125 30.5C17.7125 30.475 17.969 30.356 18.182 30.143C18.395 29.93 18.501 29.674 18.5 29.375C18.5 29.025 18.3875 28.744 18.1625 28.532C17.9375 28.32 17.65 28.226 17.3 28.25C16.275 28.325 15.1875 28.044 14.0375 27.407C12.8875 26.77 12.1625 25.6135 11.8625 23.9375C11.8125 23.6625 11.6815 23.4375 11.4695 23.2625C11.2575 23.0875 11.0135 23 10.7375 23C10.3875 23 10.1 23.1315 9.875 23.3945C9.65 23.6575 9.575 23.9635 9.65 24.3125C10.075 26.5875 11.075 28.2125 12.65 29.1875C14.225 30.1625 15.8125 30.6 17.4125 30.5ZM17 35C13.575 35 10.719 33.825 8.432 31.475C6.145 29.125 5.001 26.2 5 22.7C5 20.2 5.994 17.4815 7.982 14.5445C9.97 11.6075 12.976 8.426 17 5C21.025 8.425 24.0315 11.6065 26.0195 14.5445C28.0075 17.4825 29.001 20.201 29 22.7C29 26.2 27.8565 29.125 25.5695 31.475C23.2825 33.825 20.426 35 17 35Z" fill="#6FFEFB"/>
            </g>
            <defs>
            <filter id="filter0_f_309_7" x="0.3" y="0.3" width="33.4" height="39.4" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
            <feFlood flood-opacity="0" result="BackgroundImageFix"/>
            <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
            <feGaussianBlur stdDeviation="2.35" result="effect1_foregroundBlur_309_7"/>
            </filter>
            </defs>
        </svg>
    ]]);

    ['progress-speed'] = svgCreate(180 * scale, 7 * scale, [[
        <svg width="180" height="7" viewBox="0 0 180 7" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect opacity="0.95" x="0.45459" y="0.200195" width="179.436" height="6.45455" fill="white"/>
        </svg>
    ]]);

    ['gear-stroke'] = svgCreate(33 * scale, 33 * scale, [[
        <svg width="33" height="33" viewBox="0 0 33 33" fill="none" xmlns="http://www.w3.org/2000/svg">
            <circle cx="16.6998" cy="16.2999" r="15.4909" stroke="white" stroke-width="1.29091"/>
        </svg>
    ]]);

    ['icon-station'] = svgCreate(21 * scale, 21 * scale, [[
        <svg width="21" height="21" viewBox="0 0 21 21" fill="none" xmlns="http://www.w3.org/2000/svg">
            <g clip-path="url(#clip0_254_166)">
            <path d="M1.63637 2.58182C1.63637 1.89708 1.90838 1.24038 2.39257 0.756197C2.87675 0.272012 3.53345 0 4.21819 0L11.9636 0C12.6484 0 13.3051 0.272012 13.7893 0.756197C14.2734 1.24038 14.5455 1.89708 14.5455 2.58182V12.9091C15.2302 12.9091 15.8869 13.1811 16.3711 13.6653C16.8553 14.1495 17.1273 14.8062 17.1273 15.4909V16.1364C17.1273 16.3075 17.1953 16.4717 17.3163 16.5928C17.4374 16.7138 17.6015 16.7818 17.7727 16.7818C17.9439 16.7818 18.1081 16.7138 18.2291 16.5928C18.3502 16.4717 18.4182 16.3075 18.4182 16.1364V10.3273H17.7727C17.6015 10.3273 17.4374 10.2593 17.3163 10.1382C17.1953 10.0172 17.1273 9.853 17.1273 9.68182V5.64773C17.1273 5.47654 17.1953 5.31237 17.3163 5.19132C17.4374 5.07028 17.6015 5.00227 17.7727 5.00227H19.7026C19.6884 4.3878 19.6342 3.8482 19.4432 3.42478C19.3409 3.17858 19.1627 2.97146 18.9345 2.83355C18.697 2.69155 18.3356 2.58182 17.7727 2.58182C17.6015 2.58182 17.4374 2.51382 17.3163 2.39277C17.1953 2.27172 17.1273 2.10755 17.1273 1.93636C17.1273 1.76518 17.1953 1.601 17.3163 1.47996C17.4374 1.35891 17.6015 1.29091 17.7727 1.29091C18.5008 1.28919 19.1084 1.43377 19.5955 1.72465C20.0899 2.01898 20.4139 2.43595 20.6205 2.89551C21.0013 3.74105 21 4.78669 21 5.58189V9.68182C21 9.853 20.932 10.0172 20.811 10.1382C20.6899 10.2593 20.5257 10.3273 20.3545 10.3273H19.7091V16.1364C19.7091 16.6499 19.5051 17.1424 19.1419 17.5056C18.7788 17.8687 18.2863 18.0727 17.7727 18.0727C17.2592 18.0727 16.7667 17.8687 16.4035 17.5056C16.0404 17.1424 15.8364 16.6499 15.8364 16.1364V15.4909C15.8364 15.1485 15.7004 14.8202 15.4583 14.5781C15.2162 14.336 14.8878 14.2 14.5455 14.2V19.3636H15.1909C15.3621 19.3636 15.5263 19.4316 15.6473 19.5527C15.7684 19.6737 15.8364 19.8379 15.8364 20.0091C15.8364 20.1803 15.7684 20.3444 15.6473 20.4655C15.5263 20.5865 15.3621 20.6545 15.1909 20.6545H0.990914C0.819728 20.6545 0.655554 20.5865 0.534508 20.4655C0.413462 20.3444 0.345459 20.1803 0.345459 20.0091C0.345459 19.8379 0.413462 19.6737 0.534508 19.5527C0.655554 19.4316 0.819728 19.3636 0.990914 19.3636H1.63637V2.58182ZM4.86364 2.58182C4.69246 2.58182 4.52828 2.64982 4.40724 2.77087C4.28619 2.89191 4.21819 3.05609 4.21819 3.22727V9.68182C4.21819 9.853 4.28619 10.0172 4.40724 10.1382C4.52828 10.2593 4.69246 10.3273 4.86364 10.3273H11.3182C11.4894 10.3273 11.6535 10.2593 11.7746 10.1382C11.8956 10.0172 11.9636 9.853 11.9636 9.68182V3.22727C11.9636 3.05609 11.8956 2.89191 11.7746 2.77087C11.6535 2.64982 11.4894 2.58182 11.3182 2.58182H4.86364Z" fill="white"/>
            </g>
            <defs>
            <clipPath id="clip0_254_166">
            <rect width="20.6545" height="20.6545" fill="white" transform="translate(0.345459)"/>
            </clipPath>
            </defs>
        </svg>
    ]]);

    ['rectangle'] = svgCreate(44 * scale, 43 * scale, [[
        <svg width="44" height="43" viewBox="0 0 44 43" fill="none" xmlns="http://www.w3.org/2000/svg">
            <g opacity="0.95" filter="url(#filter0_b_254_157)">
            <rect x="0.109131" y="0.399902" width="43.8909" height="42.6" rx="5.16364" fill="white"/>
            </g>
            <defs>
            <filter id="filter0_b_254_157" x="-54.1091" y="-53.8183" width="152.327" height="151.036" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
            <feFlood flood-opacity="0" result="BackgroundImageFix"/>
            <feGaussianBlur in="BackgroundImageFix" stdDeviation="27.1091"/>
            <feComposite in2="SourceAlpha" operator="in" result="effect1_backgroundBlur_254_157"/>
            <feBlend mode="normal" in="SourceGraphic" in2="effect1_backgroundBlur_254_157" result="shape"/>
            </filter>
            </defs>
        </svg>
    ]]);

    ['icon-engine'] = svgCreate(27 * scale, 27 * scale, [[
        <svg width="27" height="27" viewBox="0 0 27 27" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M8.0212 4.73975V6.89126H11.2485V9.04278H8.0212L5.86968 11.1943V14.4216H3.71817V11.1943H1.56665V19.8004H3.71817V16.5731H5.86968V19.8004H9.09695L11.2485 21.9519H19.8545V17.6488H22.006V20.8761H25.2333V10.1185H22.006V13.3458H19.8545V9.04278H13.4V6.89126H16.6273V4.73975H8.0212Z" fill="white"/>
        </svg>
    ]]);
    
    ['icon-light'] = svgCreate(29 * scale, 29 * scale, [[
        <svg width="29" height="29" viewBox="0 0 29 29" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M4.32311 3.34229C4.32311 3.34229 5.2439 4.26307 6.15913 5.63703C6.79148 6.59054 7.44046 7.76647 7.77882 9.04225L10.0697 8.53194L10.2916 9.50819L7.96741 10.0241C8.00069 10.2792 8.01733 10.5344 8.01733 10.7951C8.01733 12.7365 6.98561 13.8126 6.09812 14.7001L6.04819 14.75L10.0697 13.8569L10.2916 14.8332L4.95546 16.0202C4.65593 16.5084 4.46733 17.0852 4.46733 17.8951C4.46733 18.6994 4.67257 19.5259 4.98874 20.3135L10.0697 19.1819L10.2916 20.1582L5.41585 21.2398C5.64882 21.6891 5.90397 22.1107 6.15913 22.499C7.0189 23.7858 7.87312 24.6401 7.87312 24.6401L7.16312 25.3501C7.16312 25.3501 6.24233 24.4293 5.3271 23.0537C5.01093 22.5766 4.68921 22.0386 4.40632 21.4673L2.30405 21.9332L2.08218 20.9569L3.99585 20.5298C3.67968 19.6978 3.4689 18.8103 3.4689 17.8951C3.4689 17.2794 3.57429 16.7524 3.74069 16.2865L2.30405 16.6082L2.08218 15.6319L4.37858 15.1216C4.69476 14.6945 5.04976 14.3284 5.38811 13.9901C6.27562 13.1026 7.0189 12.4037 7.0189 10.7951C7.0189 10.612 7.0078 10.429 6.98561 10.2404L2.30405 11.2832L2.08218 10.3069L6.79702 9.25858C6.49194 8.14921 5.91507 7.07311 5.3271 6.19116C4.46733 4.90207 3.61312 4.04785 3.61312 4.04785L4.32311 3.34229ZM14.6181 6.85679C17.1419 6.85679 20.4257 7.93843 23.0216 9.45272C24.3174 10.2071 25.4456 11.0724 26.2299 11.9377C27.0143 12.7975 27.4314 13.6462 27.4314 14.3451C27.4314 15.044 27.0143 15.8926 26.2299 16.7524C25.4456 17.6177 24.3174 18.483 23.0216 19.2374C20.4257 20.7517 17.1419 21.8333 14.6181 21.8333C14.5349 21.8333 14.3851 21.7612 14.1799 21.4007C13.9691 21.0346 13.7694 20.4466 13.6086 19.7255C13.2869 18.2889 13.1205 16.3142 13.1205 14.3451C13.1205 12.3759 13.2869 10.4012 13.6086 8.9646C13.7694 8.2435 13.9691 7.65554 14.1799 7.28944C14.3851 6.9289 14.5349 6.85679 14.6181 6.85679Z" fill="white"/>
        </svg>
    ]]);

    ['icon-door'] = svgCreate(27 * scale, 27 * scale, [[
        <svg width="27" height="27" viewBox="0 0 27 27" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M8.47108 2.50391L3.0896 13.2648C4.28974 14.4902 5.78942 16.2299 7.04402 18.1763C8.27946 20.0976 9.26781 22.1953 9.41909 24.1871H23.0493L22.2727 2.50391H8.47108ZM9.19721 3.66371H20.7952L21.1986 13.3455H4.65886L9.19721 3.66371ZM13.5742 4.57087L6.46412 12.3773L18.0369 4.57087H13.5742ZM17.8705 14.5053H21.0978V15.413H17.8705V14.5053Z" fill="white"/>
        </svg>
    ]]);

    ['icon-belt'] = svgCreate(30 * scale, 30 * scale, [[
        <svg width="30" height="29" viewBox="0 0 30 29" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M15.0544 12.5706C14.089 12.5706 13.1452 12.2843 12.3425 11.748C11.5398 11.2116 10.9142 10.4493 10.5447 9.55733C10.1753 8.6654 10.0786 7.68394 10.2669 6.73707C10.4553 5.7902 10.9202 4.92045 11.6028 4.23779C12.2855 3.55514 13.1552 3.09024 14.1021 2.9019C15.049 2.71356 16.0304 2.81022 16.9224 3.17967C17.8143 3.54912 18.5767 4.17476 19.113 4.97748C19.6494 5.7802 19.9356 6.72394 19.9356 7.68936C19.9342 8.9835 19.4194 10.2242 18.5043 11.1393C17.5892 12.0544 16.3485 12.5691 15.0544 12.5706ZM23.0419 24.1081H9.41434L22.7413 12.3487C22.7863 12.309 22.8272 12.2647 22.8633 12.2167C22.9849 12.0545 23.0479 11.8558 23.0419 11.6532C23.0363 11.4849 22.9829 11.3218 22.8881 11.1827C22.7933 11.0437 22.6608 10.9345 22.5063 10.8678C22.3517 10.8012 22.1814 10.7799 22.0152 10.8064C21.849 10.8329 21.6937 10.9061 21.5675 11.0175L18.8451 13.4193C17.6008 12.8311 16.2368 12.5404 14.8608 12.5701C13.4848 12.5998 12.1346 12.9491 10.9168 13.5904C9.69906 14.2317 8.64714 15.1475 7.84419 16.2653C7.04125 17.3831 6.50928 18.6724 6.29034 20.0312C6.28383 20.0715 6.28013 20.1123 6.27924 20.1532L6.1794 24.9767C6.17689 25.0949 6.19799 25.2123 6.24147 25.3222C6.28494 25.432 6.34992 25.5321 6.43258 25.6165C6.51524 25.701 6.61393 25.768 6.72285 25.8138C6.83178 25.8596 6.94875 25.8831 7.0669 25.8831H23.0419C23.2773 25.8831 23.503 25.7896 23.6695 25.6232C23.8359 25.4567 23.9294 25.231 23.9294 24.9956C23.9294 24.7602 23.8359 24.5345 23.6695 24.368C23.503 24.2016 23.2773 24.1081 23.0419 24.1081ZM21.724 16.0097C21.5997 15.9946 21.4738 16.0061 21.3543 16.0431C21.2348 16.0802 21.1245 16.1422 21.0306 16.2249L14.1081 22.3331H23.0419C23.2773 22.3331 23.503 22.2396 23.6695 22.0732C23.8359 21.9067 23.9294 21.681 23.9294 21.4456C23.9326 19.6363 23.38 17.8696 22.3463 16.3846C22.2749 16.2818 22.1825 16.1952 22.0753 16.1305C21.968 16.0659 21.8483 16.0247 21.724 16.0097Z" fill="white"/>
        </svg>
    ]]);

};

addEventHandler('onClientRender', root, function ()
    
    if (getElementData(localPlayer, "guetto.showning.hud")) then 
        return 
    end
    
    instance.x = position.x;
    instance.interpolates.money = interpolate(0, getPlayerMoney(localPlayer), 0.05, 'money');
    
    dxSetBlendMode('add')

        for key, value in ipairs(config.components) do 
            local width, height = value.size[1] * scale, value.size[2] * scale;
            local backgroundSize = 60 * scale

            local x = instance.x + (backgroundSize - width) / 2
            local y = position.y + (backgroundSize - height) / 2

            local backgroundX, backgroundY = instance.x - 72 * scale / 2 + 60 * scale / 2, position.y - 72 * scale / 2 + 60 * scale / 2

            
            local adjustedY = position.y + (backgroundSize - height) / 2
            
            dxSetBlendMode('modulate_add')
                if value.id ~= 'armor' or getPedArmor(localPlayer) ~= 0 then
                    dxDrawImage(instance.x, position.y, backgroundSize, backgroundSize, instance.svg['background'], 0, 0, 0, tocolor(255, 255, 255))
                    dxDrawImage(value.id == 'food' and x + 3 * scale or x, value.id == 'life' and adjustedY + 2.2 * scale or adjustedY, width, height, instance.svg[value.id], 0, 0, 0, tocolor(255, 255, 255, 255))
                    drawItem(value.id, backgroundX, backgroundY, tocolor(value.color[1], value.color[2], value.color[3]), 0)
                end
            dxSetBlendMode('add')
                
            setOffset(value.id, value.func(localPlayer))
        
            instance.x = instance.x + backgroundSize + 20 * scale
        end

    dxSetBlendMode('blend')

    dxDrawText("$ "..formatNumber(instance.interpolates.money, '.'), instance.x - 25 * scale, position.y + 50 * scale + 31 * scale, 0, 0, tocolor(212, 214, 225, 255), 1, exports["guetto_assets"]:dxCreateFont('bold', 25), 'right', 'top')
    dxDrawText("GP "..formatNumber((getElementData(localPlayer, 'guetto.points') or 0), '.'), instance.x - 25 * scale, position.y + 85 * scale + 31 * scale, 0, 0, tocolor(204, 204, 204, 255), 1, exports["guetto_assets"]:dxCreateFont('regular', 19), 'right', 'top')

    if (getPedOccupiedVehicle(localPlayer)) then 
        local speed = math.floor(getElementSpeed(getPedOccupiedVehicle(localPlayer)), 'km/h')
        local gas = (getElementData(getPedOccupiedVehicle(localPlayer), 'vehicle:fuel') or 0);
        
        local default_text = (string.len(speed) <= 1 and '00'..speed or string.len(speed) <= 2 and '0'..speed or string.len(speed) <= 3 and speed)
        local current_gear = getVehicleCurrentGear (getPedOccupiedVehicle(localPlayer));

        dxDrawImage(positionSpeed.x + 4 * scale, positionSpeed.y + 87 * scale, 180 * scale, 7 * scale, instance.svg['progress-speed'], 0, 0, 0, tocolor(36, 39, 50, 255))
        dxDrawImage(positionSpeed.x + 4 * scale, positionSpeed.y + 87 * scale, 180 * scale / 100 * gas, 7 * scale, instance.svg['progress-speed'], 0, 0, 0, tocolor(172, 205, 132, 255))
        
        dxDrawText(default_text, positionSpeed.x, positionSpeed.y + 5 * scale, 164 * scale, 72 * scale, tocolor(212, 214, 225, 0.46 * 255), 1, exports["guetto_assets"]:dxCreateFont('bold', 80), 'center', 'center')
        dxDrawText('km/h', positionSpeed.x + 180 * scale, positionSpeed.y + 38 * scale, 40 * scale, 30 * scale, tocolor(212, 214, 225, 255), 1, exports["guetto_assets"]:dxCreateFont('regular', 15), 'center', 'center')
       
        dxSetBlendMode('add')
            dxDrawImage(positionSpeed.x + (190) * scale, positionSpeed.y + 71 * scale, 21 * scale, 21 * scale, instance.svg['icon-station'])
            dxDrawImage(positionSpeed.x + (169+10) * scale, positionSpeed.y + 5 * scale, 33 * scale, 33 * scale, instance.svg['gear-stroke'])
            
            dxDrawImage(positionSpeed.x + (162) * scale, positionSpeed.y + 99 * scale, 43 * scale, 42 * scale, instance.svg['rectangle'], 0, 0, 0, tocolor(36, 39, 50, 255))
            dxDrawImage(positionSpeed.x + (108) * scale, positionSpeed.y + 99 * scale, 43 * scale, 42 * scale, instance.svg['rectangle'], 0, 0, 0, tocolor(36, 39, 50, 255))
            dxDrawImage(positionSpeed.x + (54) * scale, positionSpeed.y + 99 * scale, 43 * scale, 42 * scale, instance.svg['rectangle'], 0, 0, 0, tocolor(36, 39, 50, 255))
            dxDrawImage(positionSpeed.x, positionSpeed.y + 99 * scale, 43 * scale, 42 * scale, instance.svg['rectangle'], 0, 0, 0, tocolor(36, 39, 50, 255))

            dxDrawImage(positionSpeed.x + (169) * scale, positionSpeed.y + 107 * scale, 30 * scale, 30 * scale, instance.svg['icon-belt'], 0, 0, 0, getElementData(localPlayer, 'belt') and tocolor(172, 205, 132, 255) or tocolor(186, 186, 186, 255));
            dxDrawImage(positionSpeed.x + (117) * scale, positionSpeed.y + 108 * scale, 27 * scale, 27 * scale, instance.svg['icon-door'], 0, 0, 0, isVehicleLocked(getPedOccupiedVehicle(localPlayer)) and tocolor(172, 205, 132, 255) or tocolor(186, 186, 186, 255));
            dxDrawImage(positionSpeed.x + (61) * scale, positionSpeed.y + 107 * scale, 29 * scale, 29 * scale, instance.svg['icon-light'], 0, 0, 0, isVehicleLight(getPedOccupiedVehicle(localPlayer)) and tocolor(172, 205, 132, 255) or tocolor(186, 186, 186, 255));
            dxDrawImage(positionSpeed.x + (9) * scale, positionSpeed.y + 107 * scale, 27 * scale, 27 * scale, instance.svg['icon-engine'], 0, 0, 0, tocolor(186, 186, 186, 255));
        
        dxSetBlendMode('blend')
    
        dxDrawText(current_gear, positionSpeed.x + (169+10) * scale, positionSpeed.y + 5 * scale, 33 * scale, 33 * scale, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont('regular', 15), 'center', 'center')

    end

    local text = "FPS: "..(math.floor (instance.fps)).." | LEVEL: "..(getElementData(localPlayer, "Level") or 0).." | ID: "..(getElementData (localPlayer, "ID") or 0).." | Data: "..os.date ("%d/%m/%y", os.time ()).." | Hora: "..os.date ("%H:%M", os.time ()).."  "..(instance.voiceEnabled and "#16c934FALANDO" or "#B03535NORMAL").." ⬤"

    dxDrawText (
        text, 
        instance.x - 250 * scale, 
        screen.y - 20  * scale - 10 * scale, 240 * scale, 20  * scale, 
        tocolor (255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont('regular', 15), "right", "top", false, false, false, true
    );

end)


addEventHandler('onClientResourceStart', resourceRoot, function ( )
    instance.interpolates.armor = createCircleStroke('armor', 72 * scale, 72 * scale, instance.stroke * scale);
    instance.interpolates.life = createCircleStroke('life', 72 * scale, 72 * scale, instance.stroke * scale);
    instance.interpolates.food = createCircleStroke('food', 72 * scale, 72 * scale, instance.stroke * scale);
    instance.interpolates.thirst = createCircleStroke('thirst', 72 * scale, 72 * scale, instance.stroke * scale);

    for key, value in ipairs (config.components_hud) do 
        setPlayerHudComponentVisible(value, false)
    end
end)

addEventHandler ('onClientPreRender', root, function (msSinceLastFrame)
    local now = getTickCount ();
    if (now >= instance.nextTick) then
        instance.fps = (1 / msSinceLastFrame) * 1000;
        instance.nextTick = now + 1000;
    end
end)

function getElementSpeed(vehicle, unit)
    if isElement(vehicle) then
        local vx, vy, vz = getElementVelocity(vehicle)
        return math.floor(math.sqrt(vx*vx + vy*vy + vz*vz) * 187.5)
    end
end
addEventHandler("onClientPlayerVoiceStart",localPlayer,function()
    if not instance.voiceEnabled then 
        instance.voiceEnabled = true 
    end
end)


addEventHandler("onClientPlayerVoiceStop",localPlayer,function()
    if instance.voiceEnabled then 
        instance.voiceEnabled = false
    end
end)


function isVehicleLight (vehicle)
    if not vehicle then 
        return 0 
    end
    local isDoorAjar = false
	for i=0,5 do
		local doorState = getVehicleLightState(vehicle, i)
		if doorState == 1 or doorState == 3 or doorState == 4 then
			isDoorAjar = true
		end
	end
	
	return isDoorAjar
end
