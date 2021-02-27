async function tiposrecipiente(request, response){
    const urlTiposrecipiente = process.env.URL_TIPOS_RECIPIENTE;
    const tiposRecipienteResponse = await fetch(`${urlTiposrecipiente}`);
    const tiposRecipienteResponseJson = await tiposRecipienteResponse.json();

    response.setHeader('Cache-Control', 's-maxage=10, stale-while-revalidate');

    response.json(
        {
            tiposRecipiente: tiposRecipienteResponseJson
        }
    )
}

export default tiposrecipiente;