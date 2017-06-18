class ContactsController < ApplicationController
  
  
  # GET request to /contact-us
  # Show new contact form
  def new
    @contact = Contact.new
  end
  
  #POST request /contacts
  def create
    #mass assignment of form fields into contact object
    @contact = Contact.new(contact_params)
    #save the contact object ot database
    if @contact.save
      #store form fields via parameters into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      #plug variables into the contactmailer email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      #store success message in flash hash and redirect to  new action
      flash[:success] = "Message sent"
      redirect_to new_contact_path
    else
      #if contact object doesn't save, store errors in flash hash and redirect
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  private
  #to collect date from forms, we need to use strong parameters and
  #whitelist the parameters
    def contact_params
       params.require(:contact).permit(:name, :email, :comments)
    end
end