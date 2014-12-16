class InvoicesController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  def index
    @invoices = Invoice.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@invoices)
  end

  def show
    respond_with(@invoice)
  end

  def new
    @invoice = Invoice.new
    respond_with(@invoice)
  end

  def edit
  end

  def create
    @invoice = Invoice.new(invoice_params)
    flash[:notice] = 'Invoice was successfully created.' if @invoice.save
    respond_with(@invoice)
  end

  def update
    flash[:notice] = 'Invoice was successfully updated.' if @invoice.update(invoice_params)
    respond_with(@invoice)
  end

  def destroy
    @invoice.destroy
    respond_with(@invoice)
  end

  private
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def invoice_params
      params.require(:invoice).permit(:rise, :content)
    end
end
