class Api::V1::StoredProductsController < ShopifyApp::AuthenticatedController
  before_action :set_stored_product, only: [:show, :edit, :update, :destroy]

  # GET /stored_products/1/edit
  def edit
    if @stored_product.shop_id == @shop.id
      @product_images = @stored_product.product_images
      @blocks = @stored_product.blocks
    else
      redirect_to root_path
    end
  end

  # PATCH/PUT /stored_products/1
  # PATCH/PUT /stored_products/1.json
  def update
    # TODO: not the best way of doing but this is POC
    # delete all the current block
    @stored_product.blocks.destroy_all

    # rebuild all the new block
    params[:blocks].each do |block|
      Block.where(block_id: block['block_id']).first_or_create do |this_block|
        this_block.image_url = block['image_url']
        this_block.block_type = block['block_type']
        this_block.block_id = block['block_id']
        this_block.block_text = block['block_text']
        this_block.stored_product_id = @stored_product.id
      end
    end

    respond_to do |format|
      if @stored_product.update(stored_product_params)
        format.html { redirect_to api_v1_stored_product_url, notice: 'Stored product was successfully updated.' }
        format.json { render :show, status: :ok, location: api_v1_stored_product_url }
      else
        format.html { render :edit }
        format.json { render json: @stored_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stored_products/1
  # DELETE /stored_products/1.json
  def destroy
    @stored_product.destroy
    respond_to do |format|
      format.html { redirect_to api_v1_stored_products_url, notice: 'Stored product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stored_product
      @stored_product = StoredProduct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stored_product_params
      params.fetch(:stored_product, {}).permit(
        :shopify_id, :shopify_title, :shopify_image_url, :lookbook_html, :shop_id
      )
    end
end
