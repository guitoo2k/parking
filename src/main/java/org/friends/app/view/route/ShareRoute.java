package org.friends.app.view.route;

import java.time.LocalDate;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.friends.app.model.Place;
import org.friends.app.model.User;
import org.friends.app.service.PlaceService;
import org.friends.app.service.UnshareException;
import org.friends.app.service.impl.DateServiceBean;
import org.friends.app.util.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import spark.ModelAndView;
import spark.Request;
import spark.Response;
import spark.utils.StringUtils;

@Component
public class ShareRoute extends AuthenticatedRoute {

	@Autowired
	private DateServiceBean dateService;
	@Autowired
	private PlaceService placeService;

	@Override
	public ModelAndView doHandle(Request request, Response response) {

		Map<String, Object> map = Routes.getMap(request);
		User user = getUser(request);

		if (user.getPlaceNumber() == null) {
			throw new RuntimeException("A user without place cannot share a place");
		}

		// Premier jour reservable
		LocalDate jour1 = dateService.getWorkingDay();
		Place canShareToday = placeService.isPlaceShared(user.getPlaceNumber(), DateUtil.dateToString(jour1));
		map.put("canShareToday", canShareToday);
		map.put("jourProchaineLiberation", DateUtil.dateToString(jour1, Locale.FRANCE));
		map.put("libelleJourProchaineLiberation", DateUtil.dateToMediumString(jour1));

		// Deuxieme jour reservable
		LocalDate jour2 = dateService.getNextWorkingDay(jour1);
		canShareToday = placeService.isPlaceShared(user.getPlaceNumber(), DateUtil.dateToString(jour2));
		map.put("canShareTomorrow", canShareToday);
		map.put("jourDeuxiemeLiberation", DateUtil.dateToString(jour2, Locale.FRANCE));
		map.put("libelleJourDeuxiemeLiberation", DateUtil.dateToMediumString(jour2));

		// Messages
		String liberationOk = request.queryParams("liberation");
		if (!StringUtils.isEmpty(liberationOk) && "ok".equalsIgnoreCase(liberationOk)) {
			map.put("success", "Libération effectuée");
		}

		String annulationOk = request.queryParams("annulation");
		if (!StringUtils.isEmpty(annulationOk) && "ok".equalsIgnoreCase(annulationOk)) {
			map.put("success", "Annulation effectuée");
		}

		/*
		 * Partage de places
		 */
		if ("POST".equalsIgnoreCase(request.requestMethod())) {
			LocalDate dateDebut = request.queryParams("dateDebut") != null
					? DateUtil.stringToDate(request.queryParams("dateDebut"), Locale.FRANCE) : null;
			LocalDate dateFin = request.queryParams("dateFin") != null
					? DateUtil.stringToDate(request.queryParams("dateFin"), Locale.FRANCE) : null;
			boolean retour = false;
			try {
				retour = placeService.sharePlaces(user, dateDebut, dateFin);

			} catch (Exception e) {
				e.printStackTrace();
				map.put("message", "Une erreur est survenue lors de l'enregistrement de données !");
				return new ModelAndView(map, "error.ftl");
			}
			if (!retour) {
				if (dateDebut.equals(dateFin)) {
					map.put("message", "Vous avez déjà partagé votre place pour le "
							+ DateUtil.dateToString(dateDebut, Locale.FRANCE));
				} else {
					map.put("message", "Vous avez déjà partagé ces dates !");
				}
				return new ModelAndView(map, "error.ftl");
			}
			response.redirect(Routes.PLACE_SHARE + "?liberation=ok");

		} else {
			/*
			 * Annulation d'un partage
			 */
			String unshareDate = request.queryParams("unshareDate");
			if (!StringUtils.isEmpty(unshareDate)) {
				try {
					placeService.unsharePlaceByDate(user, unshareDate);
				} catch (UnshareException e) {
					map.put("message", "Une erreur est survenue lors de l'annulation !");
					return new ModelAndView(map, "error.ftl");
				}
				response.redirect(Routes.PLACE_SHARE + "?annulation=ok");
			}

		}

		/*
		 * Liste des dates partagées
		 */
		List<Place> datesPartages = placeService.getShared(user);
		if (!datesPartages.isEmpty()) {
			map.put("datesPartages", datesPartages);
		}

		return new ModelAndView(map, "sharePlace.ftl");
	}
}
