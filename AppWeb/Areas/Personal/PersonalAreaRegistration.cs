﻿using System.Web.Mvc;

namespace AppWeb.Areas.Personal
{
    public class PersonalAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "Personal";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "Personal_default",
                "Personal/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}