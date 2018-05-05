def sessions(request):
    return {'s_username': request.session.get("username", "")}
